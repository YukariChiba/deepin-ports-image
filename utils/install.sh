#!/bin/bash

ROOTFS=`mktemp -d`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE"
DISKIMG="./results/$IMGPFX.root.$FSFMT"
BOOTIMG="./results/$IMGPFX.boot.$BOOTFMT"

if [ ! -f "./profiles/repos/$REPOPROFILE.txt" ]; then
	echo "error: repo list of profile '$REPOPROFILE' not found"
	exit 1
fi

if [ ! -f "./profiles/packages/$PKGPROFILE.txt" ]; then
	echo "error: packages list of profile '$PKGPROFILE' not found"
	exit 1
fi

readarray -t INCREPOS < ./profiles/repos/$REPOPROFILE.txt
INCPKGS+="`cat ./profiles/packages/$PKGPROFILE.txt | grep -v "^-" | xargs | sed -e 's/ /,/g'`"

if [ "$BOOTLOADER" == "extlinux" ] || [ "$BOOTLOADER" == "grub" ]; then
  INCPKGS+=",initramfs-tools"
fi

if [ "$BOOTLOADER" == "extlinux" ]; then
  INCPKGS+=",u-boot-menu"
fi

if [ ! -z $EXTRAPKGS ]; then
  INCPKGS+=",$EXTRAPKGS"
fi

if [ -e "./$DISKIMG" ]; then
	rm ./$DISKIMG
fi

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
sudo mkfs.$FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

if [ "$BOOTSIZE" -ne "0" ]; then
        if [ -e "./$BOOTIMG" ]; then
                rm ./$BOOTIMG
        fi
        dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE
        if [ "$BOOTFMT" == "fat32" ]; then
                sudo mkfs.fat -F32 ./$BOOTIMG
        else
                sudo mkfs.$BOOTFMT ./$BOOTIMG
        fi
	if [ "$BOOTLOADER" == "grub" ]; then
	  sudo mkdir -p $ROOTFS/boot/efi
	  sudo mount ./$BOOTIMG $ROOTFS/boot/efi
	else
          sudo mkdir -p $ROOTFS/boot
          sudo mount ./$BOOTIMG $ROOTFS/boot
	fi
fi

sudo mmdebstrap \
	--hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
	--include=$INCPKGS \
	--skip=check/empty \
	--architectures=$TARGET_ARCH $COMPONENTS \
	$ROOTFS \
	"${INCREPOS[@]}"
