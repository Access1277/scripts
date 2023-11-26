#!/data/data/com.termux/files/usr/bin/bash

NS='sdns.myudp.elcavlaw.com'
A='myudp.elcavlaw.com'
NS1='sdns.myudph.elcavlaw.com'
A1='myudph.elcavlaw.com'
NS2='sdns.myudp1.elcavlaw.com'
A2='myudp1.elcavlaw.com'
NS3='ns-sgfree.elcavlaw.com'
A3='sgfree.elcavlaw.com'

LOOP_DELAY=0

declare -a HOSTS=('bugg.elcavlaw.com')

DIG_EXEC="DEFAULT"
CUSTOM_DIG="/data/data/com.termux/files/home/go/bin/fastdig"

IP_HUNTER="curl -s ipinfo.io/ip"
IP_HUNTER_SUCCESS=false

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

get_public_ip() {
  local ip
  ip="$(${IP_HUNTER})"
  if [[ -n "${ip}" ]]; then
    IP_HUNTER_SUCCESS=true
  else
    IP_HUNTER_SUCCESS=false
  fi
  echo "${ip}"
}

endscript() {
  unset NS A NS1 A1 NS2 A2 NS3 A3 LOOP_DELAY HOSTS _DIG DIG_EXEC CUSTOM_DIG T R M IP_HUNTER IP_HUNTER_SUCCESS
  exit 1
}

trap endscript 2 15

check() {
  local PUBLIC_IP
  PUBLIC_IP=$(get_public_ip)
  
  if "${IP_HUNTER_SUCCESS}"; then
    echo "Public IP Address: ${PUBLIC_IP}"

    for T in "${HOSTS[@]}"; do
      for R in "${A}" "${NS}" "${A1}" "${NS1}" "${A2}" "${NS2}" "${A3}" "${NS3}"; do
        (timeout -k 3 3 "${_DIG}" "@${T}" "${R}") && M=32 || M=31
        echo -e "\e[1;${M}m\$ R:${R} D:${T}\e[0m"
      done
    done
  else
    echo "Failed to retrieve the public IP address. Check your network connection or try again later."
  fi
}

echo "DNSTT Keep-Alive script with IP Hunter <Lantin Nohanih> (v${_VER})"
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
