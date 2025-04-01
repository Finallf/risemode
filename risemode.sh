#!/bin/bash

VENDOR_ID=AA88	# Rise Mode Aura Ice 0xAA88
PRODUCT_ID=8666	# Rise Mode Aura Ice 0x8666
FILES=/dev/hidraw*

for f in $FILES; do
	FILE=${f##*/}
	VID="$(cat /sys/class/hidraw/${FILE}/device/uevent | grep -oP 'HID_ID.{10}\K.{4}')"
	PID="$(cat /sys/class/hidraw/${FILE}/device/uevent | grep -oP 'HID_ID.{19}\K.{4}')"
	if [ $VID == $VENDOR_ID ] && [ $PID == $PRODUCT_ID ]; then
		HIDRAW=$FILE
		break
	fi
done

function get_temp {
	TEMP="$(sensors 2>/dev/null | grep -oP 'Tctl.*?\+\K[0-9]+')"
	TEMP="$(printf '%x\n' $TEMP)"
}

while :; do
	get_temp
	echo -e \\x${TEMP} > /dev/${HIDRAW}
	sleep 2.1
done