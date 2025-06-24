#!/bin/bash

if [ -d "./injectbin/kernelbin/$TARGET_DEVICE" ]; then
  echo_bold "--- Found binary kernel/module/bootloader files"
  if [ -d "./injectbin/kernelbin/$TARGET_DEVICE/modules" ]; then
    echo "--- Found binary kernel modules"
    sudo mkdir -p $ROOTFS/lib/modules
    sudo cp -r ./injectbin/kernelbin/$TARGET_DEVICE/modules/* $ROOTFS/lib/modules/
  fi
  if [ -d "./injectbin/kernelbin/$TARGET_DEVICE/boot" ]; then
    echo "--- Found binary kernel/bootloader"
    sudo mkdir -p $ROOTFS/boot
    sudo cp -r ./injectbin/kernelbin/$TARGET_DEVICE/boot/* $ROOTFS/boot/
  fi
fi

if [ -d "./injectbin/firmware/$TARGET_DEVICE" ]; then
  echo_bold "--- extra firmware detected"
  sudo mkdir -p $ROOTFS/lib/firmware
  sudo cp -r ./injectbin/firmware/$TARGET_DEVICE/* $ROOTFS/lib/firmware/
fi

if [ -n "$(ls -A $ROOTFS/lib/modules/ 2>/dev/null)" ]
then
  for d in $ROOTFS/lib/modules/* ; do
    sudo systemd-nspawn -D $ROOTFS bash -c "depmod -a `basename $d`"
  done
fi

if [ -f $ROOTFS/sbin/update-initramfs ]; then
  echo "--- Update initramfs"
  sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
fi

if [ "$BOOTLOADER" == "extlinux" ]; then
  echo_bold "--- Use extlinux bootloader"
  DTBP=`ls $ROOTFS/usr/lib/ | grep linux-image- | head -n 1`
  if [ "$DTBP" != "" ] && [ "$BOOTSIZE" -ne "0" ]; then
    echo "--- Detected dtb with kernel in /usr/lib"
    sudo mkdir -p $ROOTFS/boot/dtbs
    sudo cp -r $ROOTFS/usr/lib/$DTBP $ROOTFS/boot/dtbs/$DTBP
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
  if [ -f $ROOTFS/sbin/grub-install ]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "grub-install --efi-directory=/boot/efi --removable"
    echo "GRUB_DISABLE_OS_PROBER=false" > $ROOTFS/etc/default/grub
    sudo systemd-nspawn -D $ROOTFS bash -c "mkdir -p /boot/grub && grub-mkconfig -o /boot/grub/grub.cfg"
  fi
fi

sudo systemd-nspawn -D $ROOTFS bash -c "apt list --installed linux-image-* | grep '/' | cut -d'/' -f1 | xargs -I @ dpkg-reconfigure @"
