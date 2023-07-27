#!/bin/bash

PFX=deepin-lpi4a-riscv64
BOOTIMG=$PFX.boot.ext4
ROOTIMG=$PFX.root.ext4

sudo fastboot flash boot $BOOTIMG
sudo fastboot flash root $ROOTIMG
