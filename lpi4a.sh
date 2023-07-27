#!/bin/bash

FSFMT=ext4
BOOTFMT=ext4
TARGET_DEVICE=lpi4a
TARGET_ARCH=riscv64
DISKSIZE=1200
BOOTSIZE=30
CACHEPATH=`pwd`/cache
REPO="https://ci.deepin.com/repo/deepin/deepin-ports/deepin-stage1/"
DTBPATH=thead/light-lpi4a.dtb
BUILDBOOTIMG=1
INCPKGS=`cat ./packages.txt | xargs | sed -e 's/ /,/g'`

#------------------------------------------------------------------------

. ./utils/common.sh

. ./utils/cleanup.sh
