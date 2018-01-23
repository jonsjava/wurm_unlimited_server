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
    ADMIN_PASSWORD1=$(whiptail --passwordbox "Admin Password for the Server" 8 78 --title "$TITLE" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ] && [ "$ADMIN_PASSWORD1" != "" ]; then
      ADMIN_PASSWORD2=$(whiptail --passwordbox "Admin Password for the Server (Again)" 8 78 --title "$TITLE" 3>&1 1>&2 2>&3)
      while [ "$ADMIN_PASSWORD2" != "$ADMIN_PASSWORD2" ] && [ "$ADMIN_PASSWORD1" != "" ]; do
        ADMIN_PASSWORD1=$(whiptail --passwordbox "Admin Password for the Server" 8 78 --title "$TITLE" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus != 0 ]; then
          exit 1
        fi
        ADMIN_PASSWORD2=$(whiptail --passwordbox "Admin Password for the Server (Again)" 8 78 --title "$TITLE" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus != 0 ]; then
          exit 1
        fi
      done
      ADMIN_PASSWORD="$ADMIN_PASSWORD1"
    elif [ $exitstatus = 0 ] && [ "$ADMIN_PASSWORD1" != "" ]; then
      ADMIN_PASSWORD=''
    else
      ADMIN_PASSWORD=''
    fi
  fi
}

function set_epic_settings(){
  if [ "$EPIC_SETTINGS" = "" ]; then
    if (whiptail --title "$TITLE" --yesno "Turn on Epic mode, where skillgain is faster and missions affect Valrei?" 8 78) then
      EPIC_SETTINGS="true"
    else
      EPIC_SETTINGS="false"
    fi
  fi
}
function set_ip(){
  if [ "$IP" = "" ]; then
    ip_list=''
    ip_count=$(ip addr|grep 'inet '|wc -l)
    for i in $(ip addr|grep 'inet '|awk '{print $2}'|cut -d'/' -f1); do ip_list="$ip_list '$i' ' '";done
    ip_whiptail="whiptail --title \"$TITLE\" --menu \"Which IP should the Wurm Unlimited Server listen on?\" 20 78 $ip_count $ip_list"
    ip_choice=$(echo $ip_whiptail|bash 3>&1 1>&2 2>&3)
    if [ "$ip_choice" = "" ]; then
      exit 1
    else
      IP="$ip_choice"
    fi
  fi
}
function set_external_port(){
  if [ "$EXTERNAL_PORT" = "" ]; then
    EXTERNAL_PORT=$(whiptail --title "$TITLE" --inputbox "What should be the external port? Leave blank for default." 8 78 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
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
            EXTERNAL_PORT=$(whiptail --title "$TITLE" --inputbox "Previous Entry '$EXTERNAL_PORT' was Invalid. What should be the external port?" 8 78 3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus != 0 ]; then
              exit 1
            fi
          fi
        done
        if [ $exitstatus != 0 ]; then
          exit 1
        fi
      fi
    fi
  fi
}

function set_if_homeserver(){
  if [ "$HOMESERVER" = "" ]; then
    if (whiptail --title "$TITLE" --yesno "Is the server is a home server ( belongs to a single kingdom )? " 8 78) then
      HOMESERVER="true"
    else
      HOMESERVER="false"
    fi
  fi
}

function set_homekingdom(){
  if [ "$HOMEKINGDOM" = "" ]; then
    homekingdom_choice=$(whiptail --title "$TITLE" --menu "Please select the Kingdom this server belongs to" 20 78 5 "0" "No Kingdom (Adventure/Creative)" "1" "Jen-Kellon (Adventure)" "2" "Mol-Rehan (Adventure)" "3" "Horde of the Summoned (Adventure)" "4" "Freedom (Creative)" 3>&1 1>&2 2>&3)
    if [ "$homekingdom_choice" = "" ]; then
      exit 1
    else
      HOMEKINGDOM="$homekingdom_choice"
    fi
  fi
}
# TODO: Add ability to create non-login servers.
LOGINSERVER="true"

function set_max_players(){
  if [ "$MAXPLAYERS" = "" ]; then
    MAXPLAYERS=$(whiptail --title "$TITLE" --inputbox "What should we set the maximum number of players to (1-200)?" 8 78 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
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
            MAXPLAYERS=$(whiptail --title "$TITLE" --inputbox "Invalid max player count. What should we set the maximum number of players to (1-200)?" 8 78 3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus != 0 ]; then
              exit 1
            fi
          fi
        done
        if [ $exitstatus != 0 ]; then
          exit 1
        fi
      fi
    fi
  fi
}

function set_query_port(){
  if [ "$QUERYPORT" = "" ]; then
    QUERYPORT=$(whiptail --title "$TITLE" --inputbox "What should be the query port? Leave blank for default." 8 78 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      if [ "$QUERYPORT" = "" ]; then
        QUERYPORT='27017'
      else
        move_on="false"
        while [ "$move_on" != "true" ]; do
          if [ "$QUERYPORT" -gt 1024 ] && [ "$QUERYPORT" -lt 65535 ] && [ "$QUERYPORT" != "$EXTERNAL_PORT" ]; then
            move_on='true'
          else
            QUERYPORT=$(whiptail --title "$TITLE" --inputbox "Port '$QUERYPORT' is invalid. What should be the query port?" 8 78 3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus != 0 ]; then
              exit 1
            fi
          fi
        done
        if [ $exitstatus != 0 ]; then
          exit 1
        fi
      fi
    fi
  fi
}

function set_server_name(){
  if [ "$SERVERNAME" = "" ]; then
    SERVERNAME=$(whiptail --title "$TITLE" --inputbox "What would you like to name your server? (No single quotes)" 8 78 3>&1 1>&2 2>&3)
    exitstatus=$?
    has_single_quote=$(echo $SERVERNAME|grep "'"|wc -l)
    while [ $has_single_quote = 1 ]; do
      SERVERNAME=$(whiptail --title "$TITLE" --inputbox "Invalid Character Detected. What would you like to name your server? (No single quotes)" 8 78 3>&1 1>&2 2>&3)
      exitstatus=$?
      if [ $exitstatus != 0]; then
        exit 1
      fi
      has_single_quote=$(echo $SERVERNAME|grep "'"|wc -l)
    done
    if [ $exitstatus != 0 ]; then
      exit 1
    fi
    if [ "$SERVERNAME" = "" ]; then
      SERVERNAME="I Forgot to Name My Server"
    fi
  fi
}

function set_server_password(){
  if [ "$SERVERPASSWORD" = "" ]; then
    SERVERPASSWORD=$(whiptail --title "$TITLE" --inputbox "What would you like the server password to be? Leave blank for none" 8 78 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
      exit 1
    fi
  fi
}

function set_server_type(){
  if [ "$HOMEKINGDOM" = "0" ]; then
    SERVER_TYPE=$(whiptail --title "$TITLE" --menu "Please select the Server Type this should run as" 20 78 5 "Creative" "Less hostile and faster timers." "Adventure" "PvP Simulator with slow timers and more hostile mobs and NPC AI" 3>&1 1>&2 2>&3)
    if [ "$SERVER_TYPE" = "" ]; then
      SERVER_TYPE="Creative"
    fi
  else
    case $HOMEKINGDOM in
      1|2|3)
        whiptail --title "$TITLE" --msgbox "Based on your Home Kingdom selection, Adventure has been selected as the server type for you." 8 78
        SERVER_TYPE="Adventure"
      ;;
      4)
        whiptail --title "$TITLE" --msgbox "Based on your Home Kingdom selection, Creative has been selected as the server type for you." 8 78
        SERVER_TYPE="Creative"
      ;;
    esac
  fi
}

function set_server_password(){
  if [ "$SERVERPASSWORD" = "" ]; then
    SERVERPASSWORD=$(whiptail --title "$TITLE" --inputbox "What would you like the server password to be? Leave blank for none" 8 78 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
      exit 1
    fi
  fi
}

function set_server_user(){
  if [ "$SERVER_USER" = "" ]; then
    user_list=''
    for i in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd); do user_list="$user_list '$i' '(Existing User)'";done
    if [ "$(echo $user_list|grep "'steam'"|wc -l)" = "0" ]; then user_list="$user_list 'steam' '(Create New)'";fi
    user_whiptail="whiptail --title \"$TITLE\" --menu \"Which user should run the wurm service?\" 20 78 10 $user_list"
    user_choice=$(echo $user_whiptail|bash 3>&1 1>&2 2>&3)
    if [ "$user_choice" = "" ]; then
      exit 1
    else
      SERVER_USER="$user_choice"
    fi
  fi
}
