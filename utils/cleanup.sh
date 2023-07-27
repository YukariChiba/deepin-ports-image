#!/bin/bash

if [ "$BUILDBOOTIMG" -eq "1" ]; then
	sudo umount $ROOTFS/boot	
fi

sudo umount $ROOTFS

