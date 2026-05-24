#!/bin/bash
TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
TEMP_C=$((TEMP/1000))
KUMA_URL="http://192.168.0.144:3001/api/push/RiaF4c0YCf?status=up&msg=OK&ping="
LIMITE=75

if [ "$TEMP_C" -lt "$LIMITE" ]; then
    curl -s "${KUMA_URL}&msg=Temp:${TEMP_C}C" > /dev/null
fi
