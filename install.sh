#!/bin/bash

usage()
{
  echo "Usage: $0 [-h|--help]"
  echo ""
  echo "Este script instala o monitoramento de temperatura no Water Cooler Rise Mode Aura Ice para sistemas Linux"
}

while [[ $# -gt 0 ]]; do
    case $1 in
    -h|--help)
      usage
      exit 0
    ;;
  esac
done

sudo cp -f risemode.py /usr/bin/
sudo cp -f risemode.service /lib/systemd/system/

sudo systemctl enable risemode.service
sudo systemctl start risemode.service
