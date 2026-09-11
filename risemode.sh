#!/bin/bash

MODE="dump"
RESET_VAL="0"

while [ $# -gt 0 ]; do
	case "$1" in
		--daemon|-d)
			MODE="daemon"
			shift
			;;
		--reset|-r)
			MODE="reset"
			if [ -n "$2" ] && [[ "$2" =~ ^[0-9]+$ ]]; then
				RESET_VAL="$2"
				shift 2
			else
				RESET_VAL="0"
				shift
			fi
			;;
		--reset=*)
			MODE="reset"
			RESET_VAL="${1#*=}"
			if ! [[ "$RESET_VAL" =~ ^[0-9]+$ ]]; then
				echo "Erro: O valor de reset deve ser numérico." >&2
				exit 1
			fi
			shift
			;;
		--help|-h)
			echo "Uso: $0 [--daemon|-d] [--reset|-r [VALOR]] [--help|-h]"
			echo "  Sem argumentos        : Exibe diagnóstico (temperatura, device, hex)."
			echo "  --daemon, -d          : Executa em segundo plano atualizando continuamente o display."
			echo "  --reset, -r [NUM]     : Envia NUM (padrão: 0) para o display e finaliza."
			exit 0
			;;
		*)
			echo "Opção desconhecida: $1" >&2
			echo "Uso: $0 [--daemon|-d] [--reset|-r [VALOR]] [--help|-h]" >&2
			exit 1
			;;
	esac
done

VENDOR_ID="AA88"  # Rise Mode Aura Ice 0xAA88
PRODUCT_ID="8666" # Rise Mode Aura Ice 0x8666

# Localizar dispositivo HID via parsing nativo do uevent (sem invocar grep/cat externos)
HIDRAW=""
for uevent in /sys/class/hidraw/hidraw*/device/uevent; do
	[ -r "$uevent" ] || continue
	content="$(< "$uevent")"
	if [[ "$content" =~ HID_ID=[^:]+:([0-9A-Fa-f]{8}):([0-9A-Fa-f]{8}) ]]; then
		vid="${BASH_REMATCH[1]}"
		pid="${BASH_REMATCH[2]}"
		# Remove zeros à esquerda para comparação normalizada em maiúsculas
		vid="${vid#"${vid%%[!0]*}"}"
		pid="${pid#"${pid%%[!0]*}"}"
		if [[ "${vid^^}" == "${VENDOR_ID^^}" && "${pid^^}" == "${PRODUCT_ID^^}" ]]; then
			dev_dir="${uevent%/device/uevent}"
			HIDRAW="${dev_dir##*/}"
			break
		fi
	fi
done

if [ -z "$HIDRAW" ] && [ "$MODE" != "dump" ]; then
	echo "Erro: Dispositivo Rise Mode Aura Ice não encontrado em /dev/hidraw*." >&2
	exit 1
fi

CACHED_SENSOR=""
SOURCE=""
TEMP_C=0
TEMP_HEX="00"

# Descoberta do caminho do sensor (executado apenas uma vez para eliminar overhead)
function discover_sensor {
	# 1. Sysfs hwmon: Intel (coretemp) e AMD (k10temp, zenpower)
	for hwmon in /sys/class/hwmon/hwmon*/name; do
		[ -r "$hwmon" ] || continue
		local drv
		drv="$(< "$hwmon")"
		case "$drv" in
			coretemp|k10temp|zenpower)
				local base="${hwmon%/name}"
				local target=""
				if [ -r "$base/temp1_input" ]; then
					target="$base/temp1_input"
				else
					for tf in "$base"/temp*_input; do
						[ -r "$tf" ] && { target="$tf"; break; }
					done
				fi

				if [ -n "$target" ]; then
					CACHED_SENSOR="$target"
					SOURCE="sysfs (${drv}: ${target##*/})"
					return 0
				fi
				;;
		esac
	done

	# 2. Sysfs thermal_zone
	for tz in /sys/class/thermal/thermal_zone*; do
		[ -r "$tz/type" ] && [ -r "$tz/temp" ] || continue
		local ttype
		ttype="$(< "$tz/type")"
		case "$ttype" in
			x86_pkg_temp|cpu-thermal|cpu_thermal|k10temp|soc_thermal|acpitz)
				CACHED_SENSOR="$tz/temp"
				SOURCE="sysfs (thermal_zone: ${ttype})"
				return 0
				;;
		esac
	done

	# 3. Fallback: lm-sensors
	if command -v sensors >/dev/null 2>&1; then
		SOURCE="sensors (lm-sensors fallback)"
		return 0
	fi

	SOURCE="indisponível"
	return 1
}

# Leitura de temperatura de alta performance (zero subshells no caminho crítico do sysfs)
function get_temp {
	if [ -n "$CACHED_SENSOR" ] && [ -r "$CACHED_SENSOR" ]; then
		local raw_temp
		raw_temp="$(< "$CACHED_SENSOR")"
		if [ -n "$raw_temp" ] && [ "$raw_temp" -gt 0 ]; then
			TEMP_C=$(( raw_temp / 1000 ))
			printf -v TEMP_HEX '%02x' "$TEMP_C"
			return
		fi
	fi

	# Fallback lm-sensors se sysfs falhou ou não foi localizado
	if command -v sensors >/dev/null 2>&1; then
		local deg
		deg="$(sensors 2>/dev/null | grep -oP '(Package id 0|Tctl|Tdie|CPU Temperature|Core 0):\s*\+\K[0-9]+' | head -n 1)"
		if [ -n "$deg" ]; then
			TEMP_C="$deg"
			printf -v TEMP_HEX '%02x' "$deg"
			return
		fi
	fi

	TEMP_C=0
	TEMP_HEX="00"
}

discover_sensor

if [ "$MODE" = "reset" ]; then
	printf -v RESET_HEX '%02x' "$RESET_VAL"

	if ! printf "\\x${RESET_HEX}\\x00" > "/dev/${HIDRAW}"; then
		echo "Erro: Falha ao enviar valor ${RESET_VAL} para /dev/${HIDRAW}." >&2
		exit 1
	fi
	echo "Display atualizado com sucesso: ${RESET_VAL} (\\x${RESET_HEX}\\x00)."
	exit 0
fi

if [ "$MODE" = "dump" ]; then
	get_temp
	echo "=== Rise Mode Aura Ice - Diagnóstico ==="
	if [ -n "$HIDRAW" ]; then
		echo "Dispositivo HID : /dev/${HIDRAW} (VID: 0x${VENDOR_ID}, PID: 0x${PRODUCT_ID})"
	else
		echo "Dispositivo HID : Não encontrado (VID: 0x${VENDOR_ID}, PID: 0x${PRODUCT_ID})"
	fi
	echo "Fonte do sensor : ${SOURCE}"
	echo "Arquivo monitor : ${CACHED_SENSOR:-Nenhum (usando fallback)}"
	echo "Temperatura     : ${TEMP_C}°C"
	echo "Payload Hex     : \\x${TEMP_HEX}\\x00"
	exit 0
fi

# Tratamento para encerramento gracioso via systemd ou terminal (SIGINT, SIGTERM)
trap 'exit 0' SIGINT SIGTERM

# Loop do modo daemon contínuo (zero forks por iteração)
while :; do
	get_temp
	if ! printf "\\x${TEMP_HEX}\\x00" > "/dev/${HIDRAW}"; then
		echo "Aviso: Falha ao escrever em /dev/${HIDRAW}. Dispositivo desconectado ou ocupado?" >&2
	fi
	sleep 2.1
done