#!/bin/bash
# IP
# ADMIN_PASSWORD
# EPIC_SETTINGS
# EXTERNAL_PORT
# HOMESERVER
# HOMEKINGDOM
# LOGINSERVER
# MAXPLAYERS
# QUERYPORT
# SERVERNAME
# SERVERPASSWORD
# SERVER_TYPE
# SERVER_USER
TITLE="Wurm Unlimited Friendly Linux Server Installer"
width=$(tput cols)
height=$(tput lines)
function set_admin_pass(){
  if [ "$ADMIN_PASSWORD" = "" ]; then
    echo "Admin Password for the Server"
    read -s ADMIN_PASSWORD1
    if [ "$ADMIN_PASSWORD1" != "" ]; then
      echo "Amin Password for the Server (Again)"
      read -s ADMIN_PASSWORD2
      while [ "$ADMIN_PASSWORD2" != "$ADMIN_PASSWORD2" ] && [ "$ADMIN_PASSWORD1" != "" ]; do
        echo "Passwords did not match. Admin Password for the Server"
        read -s ADMIN_PASSWORD1
        echo "Admin Password for the Server (Again)"
        read -s ADMIN_PASSWORD2
      done
      ADMIN_PASSWORD="$ADMIN_PASSWORD1"
    else
      ADMIN_PASSWORD=''
    fi
  fi
}

function set_epic_settings(){
  if [ "$EPIC_SETTINGS" = "" ]; then
    echo "Turn on Epic mode, where skillgain is faster and missions affect Valrei? [y|N]"
    read -n 1 turn_on_epic
    toe_lower=$(echo $turn_on_epic|tr '[:upper:]' '[:lower:]')
    if [ "$toe_lower" = "y" ]; then
      EPIC_SETTINGS="true"
    else
      EPIC_SETTINGS="false"
    fi
  fi
}
function set_ip(){
  if [ "$IP" = "" ]; then
    ip_list=''
    first_good_ip=$(ip addr|grep 'inet '|awk '{print $2}'|cut -d'/' -f1|grep "127" -v|head -1)
    echo "here are the IP addresses we can see on this server:"
    for i in $(ip addr|grep 'inet '|awk '{print $2}'|cut -d'/' -f1); do echo "    $i";done
    echo ""
    echo "Please provide the IP you wish to bind the server to. Leave blank for [$first_good_ip]"
    read ip_choice
    if [ "$ip_choice" = "" ]; then
      IP="$first_good_ip"
    else
      IP="$ip_choice"
    fi
  fi
}
function set_external_port(){
  if [ "$EXTERNAL_PORT" = "" ]; then
    echo "What should be the external port? Leave blank for default. [3724]"
    read EXTERNAL_PORT
    if [ "$EXTERNAL_PORT" = "" ]; then
      EXTERNAL_PORT='3724'
    else
      move_on="false"
      while [ "$move_on" != "true" ]; do
        if [ "$EXTERNAL_PORT" -gt 1024 ]; then
          if [ "$EXTERNAL_PORT" -lt 65535 ]; then
            move_on='true'
          fi
        else
          echo "Previous Entry '$EXTERNAL_PORT' was Invalid. What should be the external port? Leave blank for default. [3724]"
          read EXTERNAL_PORT
          if [ "$EXTERNAL_PORT" = "" ]; then
            EXTERNAL_PORT='3724'
            move_on="true"
          fi
        fi
      done
    fi
  fi
}

function set_if_homeserver(){
  if [ "$HOMESERVER" = "" ]; then
    echo "Is the server is a home server ( belongs to a single kingdom )? [Y|n]"
    read -n 1 is_homeserver
    is_homeserver_lower=$(echo $is_homeserver|tr '[:upper:]' '[:lower:]')
    if [ "$is_homeserver_lower" = "n"]; then
      HOMESERVER="false"
    else
      HOMESERVER="true"
    fi
  fi
}

function set_homekingdom(){
  if [ "$HOMEKINGDOM" = "" ]; then
    echo "There are 5 options for the Home Kingdom:
    0 - No kingdom
    1 - Jen-Kellon
    2 - Mol-Rehan
    3 - Horde of the Summoned
    4 - Freedom"
    echo ""
    echo "Please enter the number corresponding to this servers Home Kingdom. Default: [4]"
    read HOMEKINGDOM
    if [ "$HOMEKINGDOM" = "" ]; then
      HOMEKINGDOM="4"
    fi
  fi
}
# TODO: Add ability to create non-login servers.
LOGINSERVER="true"

function set_max_players(){
  if [ "$MAXPLAYERS" = "" ]; then
    echo "What should we set the maximum number of players to (1-200)? Default [200]"
    read MAXPLAYERS
    if [ "$MAXPLAYERS" = "" ]; then
      MAXPLAYERS='200'
    else
      move_on="false"
      while [ "$move_on" != "true" ]; do
        if [ "$MAXPLAYERS" -gt 0 ]; then
          if [ "$MAXPLAYERS" -lt 201 ]; then
            move_on='true'
          fi
        else
          echo "Invalid max player count. What should we set the maximum number of players to (1-200)? Default [200]"
          read MAXPLAYERS
        fi
      done
    fi
  fi
}

function set_query_port(){
  if [ "$QUERYPORT" = "" ]; then
    echo "What should be the query port? Leave blank for default. [27017]"
    read QUERYPORT
    if [ "$QUERYPORT" = "" ]; then
      QUERYPORT='27017'
    else
      move_on="false"
      while [ "$move_on" != "true" ]; do
        if [ "$QUERYPORT" -gt 1024 ] && [ "$QUERYPORT" -lt 65535 ] && [ "$QUERYPORT" != "$EXTERNAL_PORT" ]; then
          move_on='true'
        else
          echo "Port '$QUERYPORT' is invalid. What should be the query port? Leave blank for default. [27017]"
          read QUERYPORT
        fi
      done
    fi
  fi
}

function set_server_name(){
  if [ "$SERVERNAME" = "" ]; then
    echo "What would you like to name your server?"
    read SERVERNAME
    has_single_quote=$(echo $SERVERNAME|grep "'"|wc -l)
    while [ $has_single_quote = 1 ]; do
      echo "Invalid Character Detected. What would you like to name your server (No single quotes)?"
      read SERVERNAME
      has_single_quote=$(echo $SERVERNAME|grep "'"|wc -l)
    done
    if [ "$SERVERNAME" = "" ]; then
      SERVERNAME="I Forgot to Name My Server"
    fi
  fi
}

function set_server_password(){
  if [ "$SERVERPASSWORD" = "" ]; then
    echo "What would you like the server password to be? Leave blank for none"
    read SERVERPASSWORD
  fi
}

function set_server_type(){
  if [ "$HOMEKINGDOM" = "0" ]; then
    echo "Please select the Server Type this should run as"
    echo "  Creative -- Less hostile and faster timers."
    echo "  Adventure -- PvP Simulator with slow timers and more hostile mobs and NPC AI"
    echo ""
    echo "Please enter 'Adventure' or 'Creative'. Default [Creative]"
    read SERVER_TYPE
    case $SERVER_TYPE in
      Adventure)
        SERVER_TYPE="Adventure"
      ;;
      *)
        SERVER_TYPE="Creative"
      ;;
    esac
  else
    case $HOMEKINGDOM in
      1|2|3)
        echo "Based on your Home Kingdom selection, Adventure has been selected as the server type for you."
        SERVER_TYPE="Adventure"
      ;;
      4)
        echo "Based on your Home Kingdom selection, Creative has been selected as the server type for you."
        SERVER_TYPE="Creative"
      ;;
    esac
  fi
}

function set_server_password(){
  if [ "$SERVERPASSWORD" = "" ]; then
    echo "What would you like the server password to be? Leave blank for none"
    read SERVERPASSWORD
  fi
}

function set_server_user(){
  if [ "$SERVER_USER" = "" ]; then
    echo "Which user should run the Wurm service?"
    for i in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd); do
      echo "    $i (Existing User)"
    done
    if [ "$(echo $user_list|grep "'steam'"|wc -l)" = "0" ]; then
      echo "    steam (Create New)"
    fi
    echo "Enter the name of the user to run the service as. Default [steam]"
    read user_choice
    if [ "$user_choice" = "" ]; then
      SERVER_USER='steam'
    else
      SERVER_USER="$user_choice"
    fi
  fi
}
