linux_version=$(cat /etc/issue|awk '{print $1}')
if [ "$linux_version" != 'Ubuntu' ]; then
  echo "Currently, this installer only runs on Ubuntu/Ubuntu derivatives."
  exit 1
fi

ubuntu_version=$(cat /etc/issue|awk '{print $2}'|cut -d'.' -f1)
if [ $ubuntu_version -lt 16 ]; then
  echo -e "We have only tested this on Ubuntu 16.04 and above. Continue? [y/N]"
  read -n 1 continue_install
  continue_on=$(echo $continue_install|tr '[:upper:]' '[:lower:]')
  if [ "$continue_on" != 'y' ]; then
    echo "We did not receive 'Y' as a response. Exiting."
    exit 1
  fi
fi

echo "I am now going to install updates. Once complete, the server will reboot. You can continue the install right where you left"
echo "  off by re-running this installer once you have logged back in."
read -p "Press Enter to continue" </dev/tty
echo '2' > $(pwd)/.steps
apt update && apt full-upgrade -y && reboot
