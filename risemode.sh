#!/bin/bash

function get_temp {
	TEMP="$(sensors 2>/dev/null | grep -oP 'CPU.*?\+\K[0-9]+')"
	TEMP="$(printf '%x\n' $TEMP)"
}

while :; do
	get_temp
	echo -e \\x${TEMP} > /dev/INSTALL
	sleep 2.1
done