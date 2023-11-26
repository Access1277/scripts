#!/data/data/com.termux/files/usr/bin/bash

NS='sdns.myudph.elcavlaw.com'
A='myudph.elcavlaw.com'

LOOP_DELAY=0

declare -a HOSTS=('124.6.181.20')

DIG_EXEC="DEFAULT"
CUSTOM_DIG="/data/data/com.termux/files/home/go/bin/fastdig"

_VER=0.1

case "${DIG_EXEC}" in
  DEFAULT|D)
    _DIG="$(command -v dig)"
    ;;
  CUSTOM|C)
    _DIG="${CUSTOM_DIG}"
    ;;
esac

if ! command -v "${_DIG}" &>/dev/null; then
  echo "Error: Dig command not found. Please install dnsutils or check DIG_EXEC & CUSTOM_DIG variables."
  exit 1
fi

endscript() {
  unset NS A LOOP_DELAY HOSTS _DIG DIG_EXEC CUSTOM_DIG T R M
  exit 1
}

trap endscript 2 15

check() {
  for T in "${HOSTS[@]}"; do
    for R in "${A}" "${NS}" "${A1}" "${NS1}" "${A2}" "${NS2}" "${A3}" "${NS3}"; do
      (timeout -k 3 3 "${_DIG}" "@${T}" "${R}") && M=32 || M=31
      echo -e "\e[1;${M}m\$ R:${R} D:${T}\e[0m"
    done
  done
}

echo "DNSTT Keep-Alive script <Lantin Nohanih> (v${_VER})"
echo -e "DNS List: [\e[1;34m${HOSTS[*]}\e[0m]"
echo "CTRL + C to close script"

case "${1:-}" in
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
