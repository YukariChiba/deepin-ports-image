#!/bin/bash

sudo echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee $ROOTFS/etc/hostname > /dev/null
