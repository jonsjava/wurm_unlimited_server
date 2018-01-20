useradd -d /home/steam -m -s /bin/bash steam
install_files_dir="${current_dir}/install_files/"
apt-get -y install lib32gcc1 libswt-gtk-3-java zip sqlite3 python2.7
su - steam -c 'mkdir -p /home/steam/Steam'
su - steam -c 'cd /home/steam/ && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -'
su - steam -c 'cd /home/steam/ && ./steamcmd.sh +login anonymous +force_install_dir /home/steam/wu +app_update 402370 +validate +quit'

echo -e "Do you want Mods installed? [y/N]"
read -n 1 install_plugins
install_plugins_answer=$(echo $install_plugins|tr '[:upper:]' '[:lower:]')
if [ "${install_plugins_answer}" = "y" ]; then
  latest_plugin_version=$(curl -s https://github.com/ago1024/WurmServerModLauncher/releases/latest|cut -d'<' -f4|cut -d '"' -f2|rev|cut -d'/' -f1|rev|sed -e's/v//g')
  plugin_url="https://github.com/ago1024/WurmServerModLauncher/releases/download/v${latest_plugin_version}/server-modlauncher-${latest_plugin_version}.zip"
  su - steam -c "cd /home/steam/wu; wget ${plugin_url} && unzip server-modlauncher-${latest_plugin_version}.zip"
  su - steam -c "cd /home/steam/wu; chmod +x patcher.sh; ./patcher.sh"
fi
echo "Mods enabled"
echo -e "Now, you can either have [A]dventure or [C]reative server. Which one do you want? [a/C]"
read -n 1 server_type
st_lower=$(echo $server_type|tr '[:upper:]' '[:lower:]')
if [ "${st_lower}" = "c" ]; then
  server_flavor="Creative"
else
  server_flavor="Adventure"
fi
su - steam -c "cd /home/steam/wu; cp -R dist/${server_flavor} ."
cp ${install_files_dir}server.cfg /home/steam/wu/
cp ${install_files_dir}start_server.sh /home/steam/wu
chown steam:steam /home/steam/wu -R
su - steam -c "cd /home/steam/wu; chmod +x start_server.sh"
cp ${install_files_dir}wurm.service /lib/systemd/system/wurm.service
systemctl enable wurm.service
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo ""
echo "The Wurm server is now installed. It WILL NOT WORK until you:"
echo " * reconfigure /home/steam/wu/server.cfg"
echo " * open the ports outlined in the README.md"
echo ""
echo "Once you have done those things, you can then run the following:"
echo "sudo service wurm start"
echo ""
echo "To check the status of the server:"
echo "  sudo service wurm status"
echo ""
echo "To start/stop/restart:"
echo "  sudo service wurm start"
echo "  sudo service wurm stop"
echo "  sudo service wurm restart"
