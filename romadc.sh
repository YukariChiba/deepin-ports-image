#!/bin/bash

. ./utils/defaults.sh

TARGET_DEVICE=romadc
TARGET_ARCH=riscv64
DISKSIZE=2048
BOOTSIZE=256
PKGPROFILE=buildenv
REPOPROFILE=main-riscv64
COMPONENTS=standard

. ./utils/parseopt.sh

#------------------------------------------------------------------------

. ./utils/common.sh

. ./utils/cleanup.sh
