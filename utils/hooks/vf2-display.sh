#!/bin/bash

if [ "$TARGET_DEVICE" == "romadc" ]; then
  sudo install -D ./utils/hooks/vf2-display/05-x100.conf $ROOTFS/etc/X11/xorg.conf.d/05-x100.conf
fi
