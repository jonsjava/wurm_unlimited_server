#!/bin/bash
if [ "$(whoami)" != 'root' ]; then
  echo "Please run this as root. One way to do this is to run it like so:"
  echo "  sudo $0"
  exit 1
fi
current_dir=$(pwd)
current_step=$(cat .steps)
source install_steps/${current_step}.sh
