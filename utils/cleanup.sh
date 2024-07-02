#!/bin/bash

if [ "$BOOTSIZE" -ne "0" ]; then
  if [ "$BOOTLOADER" == "grub" ]; then
    sudo umount $ROOTFS/boot/efi
  else
    sudo umount $ROOTFS/boot
  fi
fi

sudo umount $ROOTFS

if [ "$BOOTFMT" == "ext4" ] && [ "$BOOTSIZE" -ne "0" ]; then
  e2label $BOOTIMG $BOOTLABEL
fi

if [ "$FSFMT" == "ext4" ]; then
  e2label $DISKIMG $ROOTLABEL
  if [ -z $NOHOOKS ] && [ -z $NORESIZE ]; then
    # templates needs more space
    e2fsck -a -f $DISKIMG
    resize2fs -M $DISKIMG
  fi
  if [ -z $NOTAILSPACE ]; then
    e2fsck -a -f $DISKIMG
    dd if=/dev/zero of=$DISKIMG bs=256M count=1 oflag=append conv=notrunc
    e2fsck -a -f $DISKIMG
    resize2fs $DISKIMG 
  fi
fi
