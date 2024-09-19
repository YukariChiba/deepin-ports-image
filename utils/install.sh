#!/bin/bash

if [ ! -f "./profiles/repos/$REPOPROFILE.txt" ]; then
	echo "error: repo list of profile '$REPOPROFILE' not found"
	exit 1
fi

if [ ! -f "./profiles/packages/$PKGPROFILE.txt" ]; then
	echo "error: packages list of profile '$PKGPROFILE' not found"
	exit 1
fi

readarray -t INCREPOS < ./profiles/repos/$REPOPROFILE.txt
if [ -f "./profiles/repos/devices/$TARGET_DEVICE.txt" ]; then
  readarray -t INCREPOS_DEV < ./profiles/repos/devices/$TARGET_DEVICE.txt
  INCREPOS=("${INCREPOS[@]}" "${INCREPOS_DEV[@]}")
fi
INCPKGS+="`cat ./profiles/packages/$PKGPROFILE.txt | grep -v "^-" | xargs | sed -e 's/ /,/g'`"

if [ "$BOOTLOADER" == "extlinux" ]; then
  INCPKGS+=",initramfs-tools"
fi

if [ "$BOOTLOADER" == "extlinux" ]; then
  INCPKGS+=",u-boot-menu"
fi

if [ ! -z $IMGGPU ]; then
  INCPKGS+=",xserver-xorg-video-pvrdri"
  for incpkg in firmware-imggpu img-gpu-bin libegl-pvr0 libgbm1-pvr libgl1-pvr-dri libglapi-pvr; do
    INCPKGS+=",$incpkg-$IMGGPU"
  done
fi

if [ ! -z $EXTRAPKGS ]; then
  INCPKGS+=",$EXTRAPKGS"
fi

sudo mmdebstrap \
	--hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
	--include=$INCPKGS \
	--skip=check/empty \
	--architectures=$TARGET_ARCH $COMPONENTS \
	$ROOTFS \
	"${INCREPOS[@]}"
