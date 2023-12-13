#!/bin/bash

ROOTFS=${1:-./rootfs}
REPOPROFILE=main-riscv64
PKGPROFILE=buildenv
TARGET_ARCH=riscv64
COMPONENTS=standard

readarray -t INCREPOS < ./profiles/repos.$REPOPROFILE.txt
INCPKGS=`cat ./profiles/packages.$PKGPROFILE.txt | grep -v "^-" | xargs | sed -e 's/ /,/g'`

sudo mmdebstrap \
	--hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
        --include=$INCPKGS \
        --architectures=$TARGET_ARCH $COMPONENTS \
        $ROOTFS \
        "${INCREPOS[@]}"
