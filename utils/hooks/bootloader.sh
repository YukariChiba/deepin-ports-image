#!/bin/bash

if [ -d "./injectbin/modules/$TARGET_DEVICE" ]; then
        sudo mkdir -p $ROOTFS/lib/modules
        sudo cp -r ./injectbin/modules/$TARGET_DEVICE/* $ROOTFS/lib/modules/
fi

if [ -d "./injectbin/kerneldeb/$TARGET_DEVICE" ]; then
        sudo mkdir -p $ROOTFS/kernelinstall
	sudo cp -r ./injectbin/kerneldeb/$TARGET_DEVICE $ROOTFS/kernelinstall/
	sudo systemd-nspawn -D $ROOTFS bash -c "(find /kernelinstall -name '*.deb' -exec dpkg -i {} \; || true) && rm -r /kernelinstall"
fi

if [ "$BOOTLOADER" == "extlinux" ]; then
  DTBP=`ls $ROOTFS/usr/lib/ | grep linux-image- | head -n 1`
  if [ "$DTBP" != "" ]; then
    sudo cp -r $ROOTFS/usr/lib/$DTBP $ROOTFS/boot/dtbs
  fi
  if [[ ${INCPKGS[@]} =~ initramfs-tools ]]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
  fi
  if [[ ${INCPKGS[@]} =~ u-boot-menu ]]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "u-boot-update || true"
  fi
fi

if [ "$BOOTLOADER" == "grub" ]; then
  if [[ ${INCPKGS[@]} =~ initramfs-tools ]]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
  fi
fi
