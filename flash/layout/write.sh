#!/bin/bash

IMGDEVICE=$1

IMGDEV=$2

if [ ! -e "./devices/$IMGDEVICE.table" ]; then
	echo "error: disk table not exists"
	exit 1
fi

if [ ! -e "$IMGDEV" ]; then
        echo "error: disk not exists"
        exit 1
fi

sudo sgdisk --load-backup=./devices/$IMGDEVICE.table $IMGDEV

