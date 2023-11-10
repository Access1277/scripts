#!/bin/bash
# Copyright © 2023 YourName
# Script to keep-alive your DNSTT server domain record query from target resolver/local DNS server
# Run this script excluded from your VPN tunnel (split VPN tunneling mode)
# Usage: $0 [loop|l]

# Your DNSTT Nameserver & your Domain `A` Record
A='myudp.elcavlaw.com'
NS='sdns.myudp.elcavlaw.com'
A1='mamawers.elcavlaw.com'
NS1='team-mamawers.elcavlaw.com'

# Repeat dig command loop time (seconds) (positive integer only)
LOOP_DELAY=5

# Add your DNS here
declare -a HOSTS=('124.6.181.20' '112.198.115.44')

# Linux' dig command executable filepath
# Select value: "CUSTOM|C" or "DEFAULT|D"
DIG_EXEC="DEFAULT"
# If set to CUSTOM, enter your custom dig executable path here
CUSTOM_DIG=/data/data/com.termux/files/home/go/bin/fastdig

VER=0.1

case "${DIG_EXEC}" in
 DEFAULT|D)
 _DIG="$(command -v dig)"
 ;;
 CUSTOM|C)
 _DIG="${CUSTOM_DIG}"
 ;;
esac

if [ ! "$_DIG" ]; then
  echo "Dig command not found. Please install dig (dnsutils) or check DIG_EXEC & CUSTOM_DIG variables."
  exit 1
fi

check() {
  for T in "${HOSTS[@]}"; do
    for R in "${A}" "${NS}" "${A1}" "${NS1}"; do
      if $_DIG "@${T}" "${R}" &> /dev/null; then
        echo -e "\e[1;32m\$ R:${R} D:${T}\e[0m"
      else
        echo -e "\e[1;31m\$ R:${R} D:${T}\e[0m"
      fi
    done
  done
}

echo "DNSTT Keep-Alive script <YourName>"
echo -e "DNS List: [\e[1;34m${HOSTS[*]}\e[0m]"
echo "CTRL + C to close script"

[[ "${LOOP_DELAY}" -eq 1 ]] && let "LOOP_DELAY++";

case "${@}" in
 loop|l)
 echo "Script loop: ${LOOP_DELAY} seconds"
 while true; do
  check
  echo '.--. .-.. . .- ... .     .-- .- .. -'
  sleep ${LOOP_DELAY}
 done
 ;;
 *)
 check
 ;;
esac

exit 0
