#!/bin/bash

set -e -u -o pipefail

cd /openvpn

if [ -n "$REGION" ]; then
  set -- "$@" '--config' "/openvpn/${REGION}.ovpn"
else
  echo "No OpenVPN config found in `pwd`/${REGION}.ovpn. Exiting."
  exit 1
fi

if [ -n "$USERNAME" -a -n "$PASSWORD" ]; then
  echo "$USERNAME" > /openvpn/auth.conf
  echo "$PASSWORD" >> /openvpn/auth.conf
  chmod 600 /openvpn/auth.conf
  set -- "$@" '--auth-user-pass' 'auth.conf'
else
  echo "OpenVPN credentials not set. Exiting."
  exit 1
fi

# LOCAL_NETWORKS is a comma-separated list of cidr masks to exclude from the tunnel
# Get the default gateway
DEF_GW=$(ip r | grep default | awk '{print $3}')
if [ -n "${LOCAL_NETWORKS}" ]; then
  IFS=","
  for cidr in ${LOCAL_NETWORKS}; do
    echo "Adding route for ${cidr} via ${DEF_GW}"
    ip route add ${cidr} via ${DEF_GW}
  done
fi

exec openvpn "$@"
