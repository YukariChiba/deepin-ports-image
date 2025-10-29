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

fallocate -l ${DISKSIZE}M ./$DISKIMG
#dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
mkfs_helper $FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

if [ "$BOOTSIZE" -ne "0" ]; then
        if [ -e "./$BOOTIMG" ]; then
                rm -f ./$BOOTIMG
        fi
	fallocate -l ${BOOTSIZE}M ./$BOOTIMG
        #dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE
        mkfs_helper $BOOTFMT ./$BOOTIMG
        sudo mkdir -p $ROOTFS/boot
        sudo mount ./$BOOTIMG $ROOTFS/boot
fi
if [ "$EFISIZE" -ne "0" ]; then
	if [ -e "./$EFIIMG" ]; then
		rm -f ./$EFIIMG
	fi
	fallocate -l ${EFISIZE}M ./$EFIIMG
	#dd if=/dev/zero of=./$EFIIMG iflag=fullblock bs=1M count=$EFISIZE
	mkfs_helper fat ./$EFIIMG
	sudo mkdir -p $ROOTFS/boot/efi
	sudo mount ./$EFIIMG $ROOTFS/boot/efi
fi

