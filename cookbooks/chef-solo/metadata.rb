name             'chef-solo'
maintainer       'Harris'
maintainer_email 'none@none.com'
license          'MIT'
description      'Installs/Configures chef-solo'
long_description 'Installs/Configures chef-solo for a Wurm Unlimited server.'
issues_url       'https://github.com/jonsjava/wurm_unlimited_server/issues'
source_url       'https://github.com/jonsjava/wurm_unlimited_server.git'
chef_version     '>= 12.1' if respond_to?(:chef_version)
%w(linuxmint ubuntu).each do |os|
  supports os
end
version '0.1.0'

depends 'java', '~> 1.50.0'
depends 'chef-sugar'
