#!/bin/bash

. ./utils/defaults.sh

TARGET_DEVICE=phytiumpi
TARGET_ARCH=arm64
DISKSIZE=3500
BUILDBOOTIMG=0

. ./utils/parseopt.sh

#------------------------------------------------------------------------

if [ "$IMGPROFILE" == "minimal" ]; then
	DISKSIZE=600
fi

. ./utils/common.sh

. ./utils/cleanup.sh
