#!/bin/bash

. ./utils/defaults.sh

BOOTFMT=ext4
TARGET_DEVICE=lpi4a
TARGET_ARCH=riscv64
DISKSIZE=1200
BOOTSIZE=30
REPO="https://ci.deepin.com/repo/deepin/deepin-ports/deepin-stage1/"
DTBPATH=thead/light-lpi4a.dtb
INCPKGS=`cat ./packages.ports.txt | xargs | sed -e 's/ /,/g'`
INITEXEC=lib/systemd/systemd
COMPONENTS=main

#------------------------------------------------------------------------

. ./utils/common.sh

. ./utils/cleanup.sh
