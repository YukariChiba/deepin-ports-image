#!/bin/bash

if [ -d "./bootbin/$TARGET_DEVICE" ]; then
  sudo cp -r ./bootbin/$TARGET_DEVICE/* $ROOTFS/boot/
fi

