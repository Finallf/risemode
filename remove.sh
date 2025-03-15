#!/bin/bash

usage(){
	echo ""
	echo "  Usage:  $0 [ -h | --help ]"
	echo ""
	echo "          Este script desinstala o monitoramento de temperatura"
	echo "          do Water Cooler Rise Mode Aura Ice do sistema."
	echo ""
}

while [[ $# -gt 0 ]]; do
	case $1 in
		-h|--help)
		usage
		exit 0
		;;
	esac
done

if [[ $UID -ne 0 ]]; then
	echo ""
	echo "  ERRO:  Este script deve ser executado como root" 1>&2
	echo ""
	exit 1
else
	echo ""
	echo "  INFO:  Desinstalando o Water Cooler Rise Mode Aura Ice:"
	echo "         Parando serviço..."
	systemctl stop risemode.service 2>/dev/null
	echo "         Desabilitando serviço..."
	systemctl disable risemode.service 2>/dev/null
	echo "         Removendo arquivos..."
	rm -f /lib/systemd/system/risemode.service 2>/dev/null
	rm -f /usr/bin/risemode 2>/dev/null
	echo ""
	echo "         Water Cooler Rise Mode Aura Ice desinstalado com sucesso!"
	echo ""
	exit 0
fi