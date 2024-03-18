#!/bin/bash

ROOTFS=`mktemp -d ./tmp/tmp.XXXXXX`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE"
DISKIMG="./results/$IMGPFX.root.$FSFMT"
BOOTIMG="./results/$IMGPFX.boot.$BOOTFMT"

if [ -e "./$DISKIMG" ]; then
        rm ./$DISKIMG
fi

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
sudo mkfs.$FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

if [ "$BOOTSIZE" -ne "0" ]; then
        if [ -e "./$BOOTIMG" ]; then
                rm ./$BOOTIMG
        fi
        dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE
        if [ "$BOOTFMT" == "fat32" ]; then
                sudo mkfs.fat -F32 ./$BOOTIMG
        else
                sudo mkfs.$BOOTFMT ./$BOOTIMG
        fi
        if [ "$BOOTLOADER" == "grub" ]; then
          sudo mkdir -p $ROOTFS/boot/efi
          sudo mount ./$BOOTIMG $ROOTFS/boot/efi
        else
          sudo mkdir -p $ROOTFS/boot
          sudo mount ./$BOOTIMG $ROOTFS/boot
        fi
fi

