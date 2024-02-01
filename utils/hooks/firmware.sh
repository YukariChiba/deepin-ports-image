#!/bin/bash

if [ -d "./injectbin/firmware/$TARGET_DEVICE" ]; then
  echo_bold "--- extra firmware detected"
  sudo mkdir -p $ROOTFS/lib/firmware
  sudo cp -r ./injectbin/firmware/$TARGET_DEVICE/* $ROOTFS/lib/firmware/
fi
