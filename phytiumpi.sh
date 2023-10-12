#!/bin/bash

. ./utils/defaults.sh

TARGET_DEVICE=phytiumpi
TARGET_ARCH=arm64
DISKSIZE=3500
BUILDBOOTIMG=0

#------------------------------------------------------------------------

if [ "$1" == "minimal" ]; then
	INCPKGS=`cat ./packages.minimal.txt | xargs | sed -e 's/ /,/g'`
	DISKSIZE=300
fi

. ./utils/common.sh

. ./utils/cleanup.sh
