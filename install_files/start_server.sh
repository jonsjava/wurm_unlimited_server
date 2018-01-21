#!/bin/bash
cd /home/steam/wu

if [ -f ./server.cfg ]; then
  source ./server.cfg
else
  echo "Unable to find server.cfg file. Quitting like a coward."
  exit 1
fi

if [ -f WurmServerLauncher-patched ]; then
  service_file='./WurmServerLauncher-patched'
else
  service_file='./WurmServerLauncher'
fi

$service_file ADMINPWD=$ADMINPWD EPICSETTINGS=$EPICSETTINGS EXTERNALPORT=$EXTERNALPORT HOMESERVER="$HOMESERVER" HOMEKINGDOM=$HOMEKINGDOM LOGINSERVER="$LOGINSERVER" MAXPLAYERS=$MAXPLAYERS QUERYPORT=$QUERYPORT SERVERNAME="$SERVERNAME" SERVERPASSWORD="$SERVERPASSWORD" START="$START" IP="$IP"
