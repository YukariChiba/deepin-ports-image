#!/bin/bash

DISKIMG="./results/$IMGPFX.root.$FSFMT"
BOOTIMG="./results/$IMGPFX.boot.$BOOTFMT"
EFIIMG="./results/$IMGPFX.efi.fat32"

if [ -e "./$DISKIMG" ]; then
        rm ./$DISKIMG
fi

if [ -z $ROOTFS ]; then
	echo "error: ROOTFS not set"
	exit 1
fi

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
sudo mkfs.$FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

if [ "$BOOTSIZE" -ne "0" ]; then
        if [ -e "./$BOOTIMG" ]; then
                rm -f ./$BOOTIMG
        fi
        dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE
        if [ "$BOOTFMT" == "fat32" ]; then
                sudo mkfs.fat -F32 ./$BOOTIMG
        else
                sudo mkfs.$BOOTFMT ./$BOOTIMG
        fi
        sudo mkdir -p $ROOTFS/boot
        sudo mount ./$BOOTIMG $ROOTFS/boot
	if [ "$EFISIZE" -ne "0" ]; then
		if [ -e "./$EFIIMG" ]; then
			rm -f ./$EFIIMG
		fi
		dd if=/dev/zero of=./$EFIIMG iflag=fullblock bs=1M count=$EFISIZE
		mkfs.fat -F32 ./$EFIIMG
		sudo mkdir -p $ROOTFS/boot/efi
		sudo mount ./$EFIIMG $ROOTFS/boot/efi
	fi
fi

