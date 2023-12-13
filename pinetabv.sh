#!/bin/bash

. ./utils/defaults.sh

TARGET_DEVICE=pinetabv
TARGET_ARCH=riscv64
DISKSIZE=1200
BOOTSIZE=0
PKGPROFILE=cli
REPOPROFILE=main-riscv64
COMPONENTS=standard

. ./utils/parseopt.sh

#------------------------------------------------------------------------

. ./utils/common.sh

. ./utils/cleanup.sh
