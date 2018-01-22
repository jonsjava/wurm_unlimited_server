#!/bin/bash
if [ "$(whoami)" != "root" ]; then
  echo "please run this script as so:"
  echo "  sudo $0"
  exit 1
fi
source server.cfg
which berks 2>&1 > /dev/null
chef_found=$?
if [ $chef_found = 1 ]; then
  echo "Please run the full_auto_installer.sh before running the update_server.sh script"
  exit 1
fi
cur_dir=$(pwd)
cd cookbooks/chef-solo
berks update
berks vendor ../
cd $cur_dir
chef-solo -c solo.rb -j solo.json
