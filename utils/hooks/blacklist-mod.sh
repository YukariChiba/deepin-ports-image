#!/bin/bash

if [ -d $ROOTFS/usr/lib/modules ]; then
  echo "blacklist evbug" | sudo tee $ROOTFS/etc/modprobe.d/disable-evbug.conf > /dev/null
fi
