#!/bin/bash

. ./utils/defaults.sh

TARGET_DEVICE=romadc
TARGET_ARCH=riscv64
DISKSIZE=1024
BOOTSIZE=256
INITEXEC=
BOOTSTRAP_ENGINE=mmdebstrap
IMGPROFILE=minimal

. ./utils/parseopt.sh

#------------------------------------------------------------------------

. ./utils/common.sh

. ./utils/cleanup.sh
