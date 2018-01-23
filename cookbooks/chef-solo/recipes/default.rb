#
# Cookbook Name:: chef-solo
# Recipe:: default
#
# Copyright (C) 2018 Harris
#
# Licensed under the MIT license.
#

service "wurm" do
  action :stop
  only_if { File.exist?("/lib/systemd/system/wurm.service") }
end

execute 'update apt repo' do
  command 'apt-get update'
  user 'root'
end
server_user = node['wurm']['server_user']
server_cfg = node['wurm']['game_config']
include_recipe 'chef-sugar::default'
include_recipe 'java::default'

package %w(lib32gcc1 libswt-gtk-3-java zip sqlite3 python2.7) if ubuntu? || linuxmint?

user server_user do
  comment 'User to run the Wurm server as'
  home "/home/#{server_user}"
  manage_home true
end

remote_file "/home/#{server_user}/steamcmd_linux.tar.gz" do
  source 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz'
  owner server_user
  group server_user
end

execute 'extract files' do
  cwd "/home/#{server_user}/"
  command 'tar -zxf steamcmd_linux.tar.gz'
  user server_user
end

execute 'change permissions' do
  cwd "/home/#{server_user}/"
  command "chown steam:steam * -R; chmod 755 /home/#{server_user}/linux32/*"
end

execute 'install Wurm Unlimited Server' do
  cwd "/home/#{server_user}"
  command "/home/#{server_user}/steamcmd.sh +login anonymous +force_install_dir /home/steam/wu +app_update 402370 +validate +quit"
  user server_user
end

execute 'download plugins and patch server start file' do
  cwd "/home/#{server_user}/wu"
  user server_user
  command "latest_plugin_version=$(curl -s https://github.com/ago1024/WurmServerModLauncher/releases/latest|cut -d'<' -f4|cut -d '\"' -f2|rev|cut -d'/' -f1|rev|sed -e's/v//g');plugin_url=\"https://github.com/ago1024/WurmServerModLauncher/releases/download/v${latest_plugin_version}/server-modlauncher-${latest_plugin_version}.zip\";wget ${plugin_url} && unzip server-modlauncher-${latest_plugin_version}.zip;chmod +x patcher.sh; ./patcher.sh"
  not_if { node['wurm']['add_mods'] == false }
end

execute 'Link world files' do
  user server_user
  cwd "/home/#{server_user}/wu"
  command "cp dist/#{node['wurm']['game_config']['server_type']} . -R"
  not_if { ::File.exist?("/home/#{server_user}/wu/Creative/gamedir") }
  notifies :create, "file[/home/#{server_user}/wu/#{node['wurm']['game_config']['server_type']}/gamedir]", :immediately
end

file "/home/#{server_user}/wu/#{node['wurm']['game_config']['server_type']}/gamedir" do
  content ''
  mode '0644'
  user server_user
  group server_user
  action :nothing
end

execute 'copy steam files' do
  cwd "/home/#{server_user}/wu"
  user server_user
  command 'cp ./linux64/steamclient.so ./nativelibs'
  not_if { ::File.exist?("/home/#{server_user}/wu/nativelibs/steamclient.so") }
end

template "/home/#{server_user}/wu/server.cfg" do
  source 'server.cfg.erb'
  owner server_user
  group server_user
  mode '0644'
  variables(
    ip: server_cfg['ip'],
    admin_password: server_cfg['admin_password'],
    epic_settings: server_cfg['epic_settings'],
    external_port: server_cfg['external_port'],
    homeserver: server_cfg['homeserver'],
    homekingdom: server_cfg['homekingdom'],
    loginserver: server_cfg['loginserver'],
    maxplayers: server_cfg['maxplayers'],
    queryport: server_cfg['queryport'],
    servername: server_cfg['servername'],
    serverpassword: server_cfg['serverpassword'],
    server_type: server_cfg['server_type']
  )
  notifies :restart, 'service[wurm]', :delayed
end

cookbook_file '/etc/rsyslog.d/wurm.conf' do
  source 'wurm.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

directory '/var/log/wurm' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

cookbook_file '/etc/logrotate.d/wurm' do
  source 'wurm_logrotate'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/lib/systemd/system/wurm.service' do
  source 'wurm.service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    server_user: server_user
  )
  notifies :run, 'execute[daemon-reload]', :immediately
  notifies :restart, 'service[wurm]', :delayed
end

cookbook_file "/home/#{server_user}/wu/start_server.sh" do
  source 'start_server.sh'
  owner server_user
  group server_user
  mode '0755'
  notifies :restart, 'service[wurm]', :delayed
end

service 'wurm' do
  action [:enable, :start]
end

execute 'daemon-reload' do
  command 'systemctl daemon-reload'
  user 'root'
  action :nothing
end
