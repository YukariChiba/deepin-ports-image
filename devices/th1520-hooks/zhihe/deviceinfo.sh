#!/bin/bash

source /etc/os-release

cat <<EOF >/etc/deviceinfo.ini
[device]
OS_NAME=$PRETTY_NAME
OS_VERSION=`cat /etc/os-version | grep OsBuild | cut -f2 -d '='`
DEVICE_BRAND=`fw_printenv DEVICE_BRAND || :`
DEVICE_MODEL=`fw_printenv DEVICE_MODEL || :`
DEVICE_SN=`fw_printenv DEVICE_SN || :`
DEVICE_UUID=`fw_printenv DEVICE_UUID || :`
EOF
