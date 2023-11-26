#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

## Your DNSTT Nameserver & your Domain `A` Record
NS='sdns.myudp.elcavlaw.com'
A='myudp.elcavlaw.com'
NS1='sdns.myudph.elcavlaw.com'
A1='myudph.elcavlaw.com'
NS2='sdns.myudp1.elcavlaw.com'
A2='myudp1.elcavlaw.com'
NS3='ns-sgfree.elcavlaw.com'
A3='sgfree.elcavlaw.com'

## Additional DNSTT Nameservers & their Domain `A` Records
NS4='additional-ns.example.com'
A4='additional-domain.example.com'
NS5='another-ns.example.com'
A5='another-domain.example.com'

## Repeat dig cmd loop time (seconds) (positive integer only)
LOOP_DELAY=0

## Add your DNS here
declare -a HOSTS=('124.6.181.20' '124.6.181.12' '124.6.183.36')

## Linux' dig command executable filepath
## Select value: "CUSTOM|C" or "DEFAULT|D"
DIG_EXEC="DEFAULT"
## if set to CUSTOM, enter your custom dig executable path here
CUSTOM_DIG="/data/data/com.termux/files/usr/bin/dig"

_VER=0.2

case "${DIG_EXEC}" in
  DEFAULT|D)
    _DIG="$(command -v dig)"
    ;;
  CUSTOM|C)
    _DIG="${CUSTOM_DIG}"
    ;;
esac

if [ ! $(command -v ${_DIG}) ]; then
  printf "%b" "Dig command failed to run, " \
    "please install busybox and dnsutils or check " \
    "\$DIG_EXEC & \$CUSTOM_DIG variable inside $( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/$(basename "$0") file.\n" && exit 1
fi

endscript() {
  unset NS A NS1 A1 NS2 A2 NS3 A3 NS4 A4 NS5 A5 LOOP_DELAY HOSTS _DIG DIG_EXEC CUSTOM_DIG T R M
  exit 1
}

trap endscript 2 15

check() {
  for T in "${HOSTS[@]}"; do
    for R in "${A}" "${NS}" "${A1}" "${NS1}" "${A2}" "${NS2}" "${A3}" "${NS3}" "${A4}" "${NS4}" "${A5}" "${NS5}"; do
      (timeout -k 3 3 "${_DIG}" "@${T}" "${R}") && M=32 || M=31
      echo -e "\e[1;${M}m\$ R:${R} D:${T}\e[0m"
    done
  done
}

echo "DNSTT Keep-Alive script <Lantin Nohanih> (v${_VER})"
echo -e "DNS List: [\e[1;34m${HOSTS[*]}\e[0m]"
echo "CTRL + C to close script"

case "${@}" in
  loop|l)
    echo "Script loop: ${LOOP_DELAY} seconds"
    while true; do
      check
      echo '.--. .-.. . .- ... .     .-- .- .. -'
      sleep "${LOOP_DELAY}"
    done
    ;;
  *)
    check
    ;;
esac

exit 0
