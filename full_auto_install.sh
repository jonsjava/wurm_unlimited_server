#!/bin/bash
which whiptail 2>&1 > /dev/null && use_whiptail=true || use_whiptail=false
if [ "$(whoami)" != "root" ]; then
  echo "please run this script as so:"
  echo "  sudo $0"
  exit 1
fi
if [ -f server.cfg ]; then
  source server.cfg
fi
for i in "$@"
do
  case $i in
    --ip=*|-i)
      IP="${i#*=}"
      shift
    ;;
    --force)
      force="true"
      shift
    ;;
    --admin_password=*|-a=*)
      ADMIN_PASSWORD="${i#*=}"
      shift
    ;;
    --epic_settings=*|-e=*)
      EPIC_SETTINGS="${i#*=}"
      shift
    ;;
    --external_port=*|-p=*)
      EXTERNAL_PORT="${i#*=}"
      shift
    ;;
    --homeserver=*|-h=*)
      HOMESERVER="${i#*=}"
      shift
    ;;
    --homekingdom=*|-k=*)
      HOMEKINGDOM="${i#*=}"
      shift
    ;;
    --loginserver=*|-l=*)
      loginserver="${i#*=}"
      shift
    ;;
    --maxplayers=*|-m=*)
      MAXPLAYERS="${i#*=}"
      shift
    ;;
    --queryport=*|-q=*)
      QUERYPORT="${i#*=}"
      shift
    ;;
    --servername=*|-n=*)
      SERVERNAME="${i#*=}"
      shift
    ;;
    --serverpassword=*|-w=*)
      SERVERPASSWORD="${i#*=}"
      shift
    ;;
    --server_type=*|-t=*)
      SERVER_TYPE="${i#*=}"
      shift
    ;;
  esac
done
if [ "$force" != "true" ]; then
  if [ ! -f /etc/lsb-release ]; then
    echo "Unknown Linux type. Exiting"
    exit 1
  fi
  source /etc/lsb-release
  release_major=$(echo $DISTRIB_RELEASE|cut -d'.' -f1)
  if [ "$DISTRIB_ID" = "Ubuntu" ] || [ "$DISTRIB_ID" = "LinuxMint" ]; then
    if [ "$DISTRIB_ID" = "Ubuntu" ]; then
      if [ "$release_major" -lt "16" ]; then
        echo "This has not been tested on Ubuntu < 16.04. Please run with the '--force' flag if you want to continue."
        exit 1
      fi
    else
      if [ "$release_major" -lt "17" ]; then
        echo "This has not been tested on LinuxMint < 17.1. Please run with the '--force' flag if you want to continue."
        exit 1
      fi
    fi
  else
    echo "Invalid Linux distro. Exiting"
    exit 1
  fi
fi
if [ "$SERVERNAME" = "" ]; then
  if [ "$use_whiptail" = "false" ]; then
    source install_steps/non_whiptail_questions.sh
  else
    source install_steps/whiptail_questions.sh
  fi
fi
set_ip
set_admin_pass
set_epic_settings
set_if_homeserver
set_homekingdom
set_server_type
set_max_players
set_query_port
set_external_port
set_server_name
set_server_password
set_server_user

echo "export IP='$IP'
export ADMIN_PASSWORD='$ADMIN_PASSWORD'
export EPIC_SETTINGS='$EPIC_SETTINGS'
export EXTERNAL_PORT='$EXTERNAL_PORT'
export HOMESERVER='$HOMESERVER'
export HOMEKINGDOM='$HOMEKINGDOM'
export LOGINSERVER='$LOGINSERVER'
export MAXPLAYERS='$MAXPLAYERS'
export QUERYPORT='$QUERYPORT'
export SERVERNAME='$SERVERNAME'
export SERVERPASSWORD='$SERVERPASSWORD'
export SERVER_TYPE='$SERVER_TYPE'
export SERVER_USER='$SERVER_USER'" > server.cfg

source server.cfg

#apt-get update
#which berks 2>&1 > /dev/null
#chef_found=$?
#if [ $chef_found = 1 ]; then
#  wget https://packages.chef.io/files/stable/chefdk/1.6.11/ubuntu/16.04/chefdk_1.6.11-1_amd64.deb
#  dpkg -i chefdk_1.6.11-1_amd64.deb
#fi
#cur_dir=$(pwd)
#cd cookbooks/chef-solo
#berks vendor ../
#cd $cur_dir
#chef-solo -c solo.rb -j solo.json
