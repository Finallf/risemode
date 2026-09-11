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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $UID -ne 0 ]]; then
	echo ""
	echo "  ERRO:  Este script deve ser executado como root (use sudo)" 1>&2
	echo ""
	exit 1
fi

echo ""
echo "  INFO:  Instalando o Water Cooler Rise Mode Aura Ice:"
echo "         Copiando executável para /usr/bin/risemode..."
cp -f "${SCRIPT_DIR}/risemode.sh" /usr/bin/risemode
chmod 755 /usr/bin/risemode

echo "         Copiando unit service para /etc/systemd/system/..."
cp -f "${SCRIPT_DIR}/risemode.service" /etc/systemd/system/risemode.service
chmod 644 /etc/systemd/system/risemode.service

echo "         Recarregando systemd..."
systemctl daemon-reload

echo "         Habilitando serviço..."
systemctl enable risemode.service

echo "         Iniciando serviço..."
systemctl restart risemode.service

echo ""
echo "         Water Cooler Rise Mode Aura Ice instalado com sucesso!"
echo ""
exit 0