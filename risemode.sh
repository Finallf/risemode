#!/bin/bash

VENDOR_ID=AA88	# Rise Mode Aura Ice 0xAA88
PRODUCT_ID=8666	# Rise Mode Aura Ice 0x8666
FILES=/dev/hidraw*


for f in $FILES; do
	FILE=${f##*/}
	VID="$(grep -oP 'HID_ID.{10}\K.{4}' "/sys/class/hidraw/${FILE}/device/uevent")"
	PID="$(grep -oP 'HID_ID.{19}\K.{4}' "/sys/class/hidraw/${FILE}/device/uevent")"
	if [[ $VID == "$VENDOR_ID" && $PID == "$PRODUCT_ID" ]]; then
		HIDRAW="/dev/$FILE"
		break
	fi
done

get_temp() {
	local temperature
	temperature="$(sensors 2>/dev/null | awk '
		/^Package id 0:/ { gsub(/[^0-9.]/, "", $4); print int($4); exit }
		/^CPU:[[:space:]]/ { gsub(/[^0-9.]/, "", $2); print int($2); exit }
	')"

	if [[ $temperature =~ ^[0-9]+$ ]]; then
		printf -v TEMP '%02x' "$temperature"
		return 0
	fi

	return 1
}

while :; do
	if [[ -n ${HIDRAW:-} ]] && get_temp; then
		printf '%b' "\\x$TEMP\\0\\0\\0\\0\\0\\0\\0\\0\\0" > "$HIDRAW"
	fi
	sleep 2.1
done