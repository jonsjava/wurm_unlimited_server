if defined?(ENV['SERVER_USER']).nil?
  default['wurm']['server_user'] = 'steam'
else
  default['wurm']['server_user'] = ENV['SERVER_USER']
end

if defined?(ENV['ADD_MODS']).nil?
  default['wurm']['add_mods'] = 'true'
else
  default['wurm']['add_mods'] = ENV['ADD_MODS']
end

if defined?(ENV['ADMIN_PASSWORD']).nil?
  default['wurm']['game_config']['admin_password'] = ''
else
  default['wurm']['game_config']['admin_password'] = ENV['ADMIN_PASSWORD']
end

if defined?(ENV['EPIC_SETTINGS']).nil?
  default['wurm']['game_config']['epic_settings'] = 'false'
else
  default['wurm']['game_config']['epic_settings'] = ENV['EPIC_SETTINGS']
end

if defined?(ENV['EXTERNAL_PORT']).nil?
  default['wurm']['game_config']['external_port'] = '3724'
else
  default['wurm']['game_config']['external_port'] = ENV['EXTERNAL_PORT']
end

if defined?(ENV['HOMESERVER']).nil?
  default['wurm']['game_config']['homeserver'] = 'true'
else
  default['wurm']['game_config']['homeserver'] = ENV['HOMESERVER']
end

if defined?(ENV['HOMEKINGDOM']).nil?
  default['wurm']['game_config']['homekingdom'] = '4'
else
  default['wurm']['game_config']['homekingdom'] = ENV['HOMEKINGDOM']
end

if defined?(ENV['LOGINSERVER']).nil?
  default['wurm']['game_config']['loginserver'] = 'true'
else
  default['wurm']['game_config']['loginserver'] = ENV['LOGINSERVER']
end

if defined?(ENV['MAXPLAYERS']).nil?
  default['wurm']['game_config']['maxplayers'] = '200'
else
  default['wurm']['game_config']['maxplayers'] = ENV['MAXPLAYERS']
end

if defined?(ENV['QUERYPORT']).nil?
  default['wurm']['game_config']['queryport'] = '27017'
else
  default['wurm']['game_config']['queryport'] = ENV['QUERYPORT']
end

if defined?(ENV['SERVERNAME']).nil?
  default['wurm']['game_config']['servername'] = 'YOUR SERVER NAME'
else
  default['wurm']['game_config']['servername'] = ENV['SERVERNAME']
end

if defined?(ENV['SERVERPASSWORD']).nil?
  default['wurm']['game_config']['serverpassword'] = ''
else
  default['wurm']['game_config']['serverpassword'] = ENV['SERVERPASSWORD']
end

if defined?(ENV['SERVER_TYPE']).nil?
  default['wurm']['game_config']['server_type'] = 'Creative'
else
  default['wurm']['game_config']['server_type'] = ENV['SERVER_TYPE']
end
