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

VENDOR_ID=AA88	# Rise Mode Aura Ice 0xAA88
PRODUCT_ID=8666	# Rise Mode Aura Ice 0x8666
FILES=/dev/hidraw*

if [[ $UID -ne 0 ]]; then
	echo ""
	echo "  ERRO:  Este script deve ser executado como root" 1>&2
	echo ""
	exit 1
else
	for f in $FILES; do
		FILE=${f##*/}
		VID="$(cat /sys/class/hidraw/${FILE}/device/uevent | grep -oP 'HID_ID.{10}\K.{4}')"
		PID="$(cat /sys/class/hidraw/${FILE}/device/uevent | grep -oP 'HID_ID.{19}\K.{4}')"
		if [ $VID == $VENDOR_ID ] && [ $PID == $PRODUCT_ID ]; then
			HIDRAW=$FILE
			break
		fi
	done

	if [ -z $HIDRAW ]; then
		echo ""
		echo "  ERRO:  Não foi possível instalar o Water Cooler Rise Mode Aura Ice!" 1>&2
		echo ""
		echo "         O Dispositivo não foi encontrado, verifique se o cabo USB do"
		echo "         Water Cooler está conectado corretamente e tente novamente. "
		echo ""
		exit 1
	else
		echo ""
		echo "  INFO:  Instalando o Water Cooler Rise Mode Aura Ice:"
		echo "         Configurando..."
		cp -f risemode.sh risemode 2>/dev/null
		sed -i "s/INSTALL/$HIDRAW/" risemode 2>/dev/null
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
fi