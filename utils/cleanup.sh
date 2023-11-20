#!/bin/bash

if [ "$BOOTSIZE" -ne "0" ]; then
	sudo umount $ROOTFS/boot	
fi

sudo umount $ROOTFS

