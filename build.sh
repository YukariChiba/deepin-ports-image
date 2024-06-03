#!/bin/bash

TARGET_DEVICE_CONF=${1:-generic}

if [ ! -f "./devices/$TARGET_DEVICE_CONF" ]; then
  echo error: device $TARGET_DEVICE_CONF config not found
  exit 1
fi

. ./utils/defaults.sh
. ./devices/$TARGET_DEVICE_CONF
if [ "$FSFMT" == "sfs" ]; then
  . ./utils/mount-sfs.sh
else
  . ./utils/mount.sh
fi
. ./utils/install.sh
. ./utils/hooks.sh
if [ "$FSFMT" == "sfs" ]; then
  . ./utils/cleanup-sfs.sh
else
  . ./utils/cleanup.sh
fi
if command -v genimage &> /dev/null; then
  . ./utils/genimage.sh
fi
