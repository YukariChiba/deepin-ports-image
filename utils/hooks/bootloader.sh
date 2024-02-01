#!/bin/bash

if [ -d "./injectbin/kernelbin/$TARGET_DEVICE" ]; then
  echo_bold "--- Found binary kernel"
  sudo mkdir -p $ROOTFS/lib/modules
  sudo mkdir -p $ROOTFS/boot
  sudo cp -r ./injectbin/kernelbin/$TARGET_DEVICE/boot/* $ROOTFS/boot/
  sudo cp -r ./injectbin/kernelbin/$TARGET_DEVICE/modules/* $ROOTFS/lib/modules/
fi

if [ -d "./injectbin/kerneldeb/$TARGET_DEVICE" ]; then
  echo_bold "--- Found deb kernel"
  sudo mkdir -p $ROOTFS/kernelinstall
  sudo cp -r ./injectbin/kerneldeb/$TARGET_DEVICE $ROOTFS/kernelinstall/
  sudo systemd-nspawn -D $ROOTFS bash -c "(dpkg -i \`find /kernelinstall -name '*.deb' | xargs\` || true) && rm -r /kernelinstall"
fi

if [ "$BOOTLOADER" == "extlinux" ]; then
  echo_bold "--- Use extlinux bootloader"
  DTBP=`ls $ROOTFS/usr/lib/ | grep linux-image- | head -n 1`
  if [ "$DTBP" != "" ] && [ "$BOOTSIZE" -ne "0" ]; then
    echo "--- Detected dtb with kernel in /usr/lib"
    sudo mkdir -p $ROOTFS/boot/dtbs
    sudo cp -r $ROOTFS/usr/lib/$DTBP $ROOTFS/boot/dtbs/$DTBP
  fi
  if [[ ${INCPKGS[@]} =~ initramfs-tools ]]; then
    echo "--- Update initramfs"
    sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
  fi
  if [ -f $ROOTFS/sbin/u-boot-update ]; then
    echo "--- u-boot-menu installed, update config"
    if [ -f "./bootconfig/uboot/$TARGET_DEVICE" ]; then
      sudo cp ./bootconfig/uboot/$TARGET_DEVICE $ROOTFS/etc/default/u-boot
    fi
    sudo mkdir -p $ROOTFS/boot/extlinux
    sudo systemd-nspawn -D $ROOTFS bash -c "u-boot-update || true"
  fi
fi

if [ "$BOOTLOADER" == "grub" ]; then
  echo_bold "--- Use grub bootloader"
  if [[ ${INCPKGS[@]} =~ initramfs-tools ]]; then
    echo "--- Update initramfs"
    sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
  fi
fi