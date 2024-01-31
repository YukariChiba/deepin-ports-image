#!/bin/bash

TARGET_DEVICE=${1:-generic}

if [ ! -f "./devices/$TARGET_DEVICE" ]; then
  echo error: device $TARGET_DEVICE config not found
  exit 1
fi

. ./utils/defaults.sh
. ./devices/$TARGET_DEVICE
. ./utils/parseopt.sh
. ./utils/install.sh
if [ -z $NOHOOKS ]; then
. ./utils/hooks.sh
fi
. ./utils/cleanup.sh
