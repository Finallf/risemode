#!/bin/bash

usage()
{
  echo "Usage: $0 [-h|--help]"
  echo ""
  echo "Este script remove completamente o monitoramento de temperatura do Water Cooler Rise Mode Aura Ice"
}

while [[ $# -gt 0 ]]; do
    case $1 in
    -h|--help)
      usage
      exit 0
    ;;
  esac
done

sudo systemctl stop risemode.service --no-warn
sudo systemctl disable risemode.service --no-warn

sudo rm -f /lib/systemd/system/risemode.service
sudo rm -f /usr/bin/risemode.py
