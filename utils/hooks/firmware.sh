#!/bin/bash

if [ -d "./injectbin/firmware/$TARGET_DEVICE" ]; then
        sudo mkdir -p $ROOTFS/lib/firmware
        sudo cp -r ./injectbin/firmware/$TARGET_DEVICE/* $ROOTFS/lib/firmware/
fi
