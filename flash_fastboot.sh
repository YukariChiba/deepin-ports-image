#!/bin/bash

PFX=deepin-lpi4a-riscv64
UBOOTIMG=$PFX.uboot.bin
BOOTIMG=$PFX.boot.ext4
ROOTIMG=$PFX.root.ext4

sudo fastboot flash ram $UBOOTIMG
sudo fastboot reboot
sleep -c 5
sudo fastboot flash uboot $UBOOTIMG
sudo fastboot flash boot $BOOTIMG
sudo fastboot flash root $ROOTIMG
