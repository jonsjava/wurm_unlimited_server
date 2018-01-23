#!/bin/bash
if [ "$(whoami)" != "root" ]; then
  echo "please run this script as so:"
  echo "  sudo $0"
  exit 1
fi
which git 2>&1 > /dev/null
git_found=$($?)
if [ $git_found = 1 ]; then
  apt-get update
  apt-get -y install
fi
cd /root/
git clone https://github.com/jonsjava/wurm_unlimited_server
cd /root/wurm_unlimited_server
git checkout deploy-overhaul
git reset --hard
git fetch
git pull origin deploy-overhaul
./full_auto_install.sh
