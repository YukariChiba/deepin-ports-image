#!/bin/bash

echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee $ROOTFS/etc/hostname > /dev/null

echo "127.0.1.1 deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee -a $ROOTFS/etc/hosts > /dev/null
