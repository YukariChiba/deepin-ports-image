#!/bin/bash

ROOTFS=`mktemp -d ./tmp/tmp.XXXXXX`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE"
DISKIMG="./results/$IMGPFX.root.$FSFMT"
BOOTIMG="./results/$IMGPFX.boot.$BOOTFMT"

if [ -e "./$DISKIMG" ]; then
        sudo rm ./$DISKIMG
fi

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
        sudo mkdir -p $ROOTFS/boot/efi
        sudo mount ./$BOOTIMG $ROOTFS/boot/efi
fi
