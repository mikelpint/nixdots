#!/usr/bin/env bash

function log {
  local NONE='\033[0m'

  echo -e "${2}${4}${NONE}"

  if [[ $5 =~ "true" && ("$INSTALLED_WOFI") ]]; then
    printf "<span weight=\"bold\" foreground=\"%s\">%s</span>\n%s" "$3" "$1" "$4" |
      wofi -d --conf="${PWD}/dialog.conf" &>/dev/null &
    disown
  fi
}

function error {
  local RED='\033[0;31m'
  log "Error" "$RED" "red" "$1" "$2"
}

function warn {
  local YELLOW='\033[0;33m'
  log "Warning" "$YELLOW" "yellow" "$1" "$2"
}

function success {
  local GREEN='\033[0;32m'
  log "Success" "$GREEN" "green" "$1" "$2"
}

function info {
  local NONE='\033[0m'
  log "" "$NONE" "white" "$1" "$2"
}

function check_dep {
  if [[ -x "$(command -v "$1")" ]]; then
    return 0
  else
    return 1
  fi
}

function notify() {
  if ((!"$INSTALLED_LIBNOTIFY")); then
    return 1
  fi

  local NOTIFY_TIMEOUT=5
  local NOTIFY_URGENCY="normal"

  notify-send \
    -t $(("$NOTIFY_TIMEOUT" * 1000)) \
    -u "$NOTIFY_URGENCY" \
    "$1" "$2" "$ICON"
}

function main_menu {
  if ((!"$INSTALLED_WOFI")); then
    return 1
  fi
}

function get_wireless_interfaces {
  if ((!"$INSTALLED_NMCLI")); then
    WIRELESS_INTERFACES=""
    return 1
  fi

  WIRELESS_INTERFACES=$(nmcli device | awk '$2=="wifi" {print $1}')
}

function get_wired_interfaces {
  if ((!"$INSTALLED_NMCLI")); then
    WIRED_INTERFACES=""
    return 1
  fi

  WIRED_INTERFACES=$(nmcli device | awk '$2=="ethernet" {print $1}')
}

function get_interfaces {
  get_wireless_interfaces
  get_wired_interfaces
}

function radio() {
  case "$1" in
  "on")
    info "Radio on"
    ;;

  "off") ;;

  *)
    warn "Invalid radio status: \"$1\""
    ;;
  esac
}

function scan {
  if (("$WIFI_STATE" < 0)); then
    return 1
  fi

  local SLEEP=2

  radio "on"
  sleep "$SLEEP"

  if [ -z ${CURRENT_WIRELESS_INTERFACE+x} ]; then
    CURRENT_WIRELESS_INTERFACE=0
  fi

  parse_wifi_list "$(
    nmcli \
      --fields SSID,SECURITY,BARS \
      device wifi list \
      ifname "${WIRELESS_INTERFACES[WLAN_INT]}" \
      --rescan yes
  )"
}

function parse_wifi_list {
  WIFI_LIST=$(
    echo -e "$1" |
      awk -F'  +' '{ if (!seen[$1]++) print}' |
      awk '$1!="--" {print}'
  )

  if [[ -n ${ACTIVE_SSID+x} ]]; then
    WIFI_LIST=$(
      echo -e "$WIFI_LIST" |
        awk '$1 !~ "^'"${ACTIVE_SSID}"'"'
    )
  fi

  (("$ASCII_OUT")) && WIFI_LIST=$(
    echo -e "$WIFI_LIST" |
      sed 's/\(..*\)\*\{4,4\}/\1▂▄▆█/g' |
      sed 's/\(..*\)\*\{3,3\}/\1▂▄▆_/g' |
      sed 's/\(..*\)\*\{2,2\}/\1▂▄__/g' |
      sed 's/\(..*\)\*\{1,1\}/\1▂___/g'
  )

  (("$CHANGE_BARS")) && WIFI_LIST=$(
    echo -e "$WIFI_LIST" |
      sed 's/\(.*\)▂▄▆█/\1'$SIGNAL_STRENGTH_4'/' |
      sed 's/\(.*\)▂▄▆_/\1'$SIGNAL_STRENGTH_3'/' |
      sed 's/\(.*\)▂▄__/\1'$SIGNAL_STRENGTH_2'/' |
      sed 's/\(.*\)▂___/\1'$SIGNAL_STRENGTH_1'/' |
      sed 's/\(.*\)____/\1'$SIGNAL_STRENGTH_0'/'
  )
}

function wireless_disconnect {
  if (("$WIFI_STATE" < 0)); then
    unset ACTIVE_SSID
    return 1
  fi

  if ((!"$WIFI_STATE")); then
    unset ACTIVE_SSID
    return 1
  fi

  if [[ -z ${ACTIVE_SSID+x} ]]; then
    return 1
  fi

  nmcli con down id "$ACTIVE_SSID"
  local RET=$?
  if ((RET)); then
    return $RET
  fi

  unset ACTIVE_SSID
  return 0
}

function net_restart {
  local SLEEP=3

  nmcli networking off &&
    sleep $SLEEP &&
    nmcli networking on
}

function gen_qrcode {
  if [[ -z ${1+x} || -z ${2+x} || -z ${3+x} ]]; then
    return 1
  fi

  local FILE_TYPE="png"
  local CONN_LEVEL="H"
  local MOD_SIZE=25
  local MARGIN_WIDTH=2
  local DPI=192

  qrencode \
    -t "$FILE_TYPE" \
    -o wifi.png \
    -l "$CONN_LEVEL" \
    -s "$MOD_SIZE" \
    -m "$MARGIN_WIDTH" \
    --dpi="$DPI" \
    "WIFI:S:${1};T:${2};P:${3};;"
}

function init {
  cd "$(dirname "${BASH_SOURCE[0]}")" || return 1

  INSTALLED=(WOFI NMCLI QRENCODE LIBNOTIFY)
  it=${#INSTALLED[@]}
  for ((i = 0; i < it; i++)); do
    name=${INSTALLED[i]}
    declare +r -g -i "INSTALLED_${name}"=0
  done

  check_dep "wofi"
  INSTALLED_WOFI=$((!"$?"))

  if ((!"$INSTALLED_WOFI")); then
    error "Wofi is not installed"
  fi

  check_dep "nmcli"
  INSTALLED_NMCLI=$((!"$?"))

  if ((!"$INSTALLED_NMCLI")); then
    error "NetworkManager CLI is not installed"
  fi

  check_dep "qrencode"
  INSTALLED_QRENCODE=$((!"$?"))

  if ((!"$INSTALLED_QRENCODE")); then
    warn "qrencode is not installed"
  fi

  check_dep "notify-send"
  INSTALLED_LIBNOTIFY=$((!"$?"))

  if ((!"$INSTALLED_LIBNOTIFY")); then
    warn "libnotify is not installed"
  fi

  return $((!(\
  INSTALLED_WOFI * \
  INSTALLED_NMCLI)))
}

init
INIT_RET="$?"

if (("$INIT_RET")); then
  exit "$INIT_RET"
fi
