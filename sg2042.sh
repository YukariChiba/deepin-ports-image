#!/bin/bash

. ./utils/defaults.sh

TARGET_DEVICE=sg2042
TARGET_ARCH=riscv64
DISKSIZE=768
BOOTSIZE=0
REPO="https://ci.deepin.com/repo/deepin/deepin-ports/deepin-stage1/"
COMPONENTS=main
IMGPROFILE=ports

. ./utils/parseopt.sh

#------------------------------------------------------------------------

. ./utils/common.sh

. ./utils/cleanup.sh
