#!/bin/bash

if [ "$BOOTSIZE" -ne "0" ]; then
  if [ "$EFISIZE" -ne "0" ]; then
    sudo umount $ROOTFS/boot/efi
  fi
  sudo umount $ROOTFS/boot
fi

sudo umount $ROOTFS

if [ "$BOOTFMT" == "ext4" ] && [ "$BOOTSIZE" -ne "0" ]; then
  e2label $BOOTIMG $BOOTLABEL
fi

if [ "$BOOTFMT" == "fat32" ] && [ "$BOOTSIZE" -ne "0" ]; then
  fatlabel $BOOTIMG $BOOTLABEL
fi

if [ "$EFISIZE" -ne "0" ]; then
  fatlabel $EFIIMG $EFILABEL
fi

if [ "$FSFMT" == "ext4" ]; then
  e2label $DISKIMG $ROOTLABEL
  e2fsck -a -f $DISKIMG
  resize2fs -M $DISKIMG
  if [ -z $NOTAILSPACE ]; then
    e2fsck -a -f $DISKIMG
    dd if=/dev/zero of=$DISKIMG bs=$TAILSPACE count=1 oflag=append conv=notrunc
    e2fsck -a -f $DISKIMG
    resize2fs $DISKIMG 
  fi
fi
