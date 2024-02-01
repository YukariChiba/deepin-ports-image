#!/bin/bash

TARGET_DEVICE_CONF=${1:-generic}

if [ ! -f "./devices/$TARGET_DEVICE_CONF" ]; then
  echo error: device $TARGET_DEVICE_CONF config not found
  exit 1
fi

. ./utils/defaults.sh
. ./devices/$TARGET_DEVICE_CONF
. ./utils/parseopt.sh
. ./utils/install.sh
. ./utils/hooks.sh
. ./utils/cleanup.sh
