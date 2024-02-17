#!/usr/bin/env bash
set -Eeo pipefail

trap "echo The script is terminated with SIGINT; exit" SIGINT
trap "echo The script is terminated with SIGTERM; exit" SIGTERM

file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(<"${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

function docker_setup_env() {
  file_env 'VPN_PASS'
  file_env 'VPN_TIMEOUT' 30
}

check_require_variable_set() {
  if [ -z "$VPN_PASS" ]; then
    echo "Variables VPN_PASS must be set."
    exit 1
  fi
}

function run() {
  # Setup masquerade, to allow using the container as a gateway
  for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
    iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
  done

  while [ true ]; do
    echo "------------ VPN Starts ------------"
    /usr/local/bin/ovpn "$@"
    echo "------------ VPN exited ------------"
    sleep 10
  done
}

_main() {
  docker_setup_env

  check_require_variable_set

  run "$@"
}

_main "$@"
3