#!/bin/bash

IMGFILE=$1

if [ ! -f "$IMGFILE" ]; then
	echo "error: image file not exists"
	exit 1
fi

IMGDEV=$2

if [ ! -e "$IMGDEV" ]; then
	echo "error: disk not exists"
	exit 1
fi

sudo dd if=$IMGFILE of=$IMGDEV seek=64M oflag=seek_bytes status=progress
