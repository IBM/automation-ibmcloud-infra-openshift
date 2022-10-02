#!/usr/bin/env bash

ROOT_DIRECTORY=$(cd $(dirname "$0"); pwd -P)
BOM_DIRECTORY="${PWD}"

VPN_REQUIRED=$(grep "vpn/required" "${BOM_DIRECTORY}/bom.yaml" | sed -E "s~[^:]+: [\"'](.*)[\"']~\1~g")
USER=$(whoami)

RUNNING_PROCESSES=$(ps -ef)
VPN_RUNNING=$(echo "${RUNNING_PROCESSES}" | grep "openvpn --config")

if [[ "${VPN_REQUIRED}" == "true" ]]; then

  if [[ -n "${VPN_RUNNING}" ]]; then
    echo "VPN required but it is already running"
  elif command -v openvpn 1> /dev/null 2> /dev/null; then
    OVPN_FILE=$(find "${ROOT_DIRECTORY}" -name "*.ovpn" | head -1)

    if [[ -z "${OVPN_FILE}" ]]; then
      echo "VPN profile not found."
      exit 1
    fi

    echo "Connecting to vpn with profile: ${OVPN_FILE}"
    if [[ "${UID}" -eq 0 ]]; then
      exec 1<&-
      exec 2<&-
      openvpn --config "${OVPN_FILE}" || true &
    elif [[ "${USER}" == "runner" ]]; then    # Caters for self hosted runner image
      exec 1<&-
      exec 2<&-
      openvpn --config "${OVPN_FILE}" || true &
    else
      exec 1<&-
      exec 2<&-
      sudo openvpn --config "${OVPN_FILE}" || true &    
    fi
  else
    echo "VPN connection required but unable to create the connection automatically. Please connect to your vpn instance using the .ovpn profile within the 110-ibm-fs-edge-vpc directory and re-run apply-all.sh."
    exit 1
  fi
else
  if [[ -n "${VPN_RUNNING}" ]]; then
    echo "VPN not required but it is already running, shutting down"
    VPN_PID=$(ps xua | grep "openvpn --config" | grep -v grep | awk '{print$1}')
    if [[ "${UID}" -eq 0 ]]; then
      kill "${VPN_PID}"
    elif [[ "${USER}" == "runner" ]]; then    # Caters for self hosted runner image
      kill "${VPN_PID}"
    else
      sudo kill "${VPN_PID}"
    fi  
  else
    echo "VPN not required"
  fi
fi