#!/bin/bash

. ./utils/defaults.sh

TARGET_DEVICE=sg2042
TARGET_ARCH=riscv64
DISKSIZE=1500
BOOTSIZE=0
PKGPROFILE=buildenv
REPOPROFILE=main-riscv64
COMPONENTS=standard

. ./utils/parseopt.sh

#------------------------------------------------------------------------

. ./utils/common.sh

. ./utils/cleanup.sh
