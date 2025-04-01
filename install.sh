#!/bin/bash

usage(){
	echo ""
	echo "  Usage:  $0 [ -h | --help ]"
	echo ""
	echo "          Este script instala o monitoramento de temperatura"
	echo "          do Water Cooler Rise Mode Aura Ice para sistemas Linux."
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
	echo "  INFO:  Instalando o Water Cooler Rise Mode Aura Ice:"
	echo "         Configurando..."
	cp -f risemode.sh risemode 2>/dev/null
	echo "         Copiando arquivos..."
	mv -f risemode /usr/bin/ 2>/dev/null
	cp -f risemode.service /lib/systemd/system/ 2>/dev/null
	echo "         Habilitando serviço..."
	systemctl enable risemode.service 2>/dev/null
	echo "         Iniciando serviço..."
	systemctl start risemode.service 2>/dev/null
	echo ""
	echo "         Water Cooler Rise Mode Aura Ice instalado com sucesso!"
	echo ""
	exit 0
fi