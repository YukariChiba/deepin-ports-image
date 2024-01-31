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

if [ ! -z $EXTRAPKGS ]; then
  if [ ! -z $NOHOOKS ]; then
    echo "error: extrapkgs should not be used with nohooks (templates)"
    exit 1 
  fi
  INCPKGS+=",$EXTRAPKGS"
fi

if [ -e "./$DISKIMG" ]; then
	rm ./$DISKIMG
fi

if [ -z $IMGTPL ]; then
  dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
  sudo mkfs.$FSFMT ./$DISKIMG
else
  TPLPFX=deepin-$IMGTPL-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE
  TPLIMG="./results/$TPLPFX.root.$FSFMT"
  if [ ! -e "./$TPLIMG" ]; then
    echo "error: template image $TPLIMG not exist"
    exit 1
  fi
  cp ./$TPLIMG ./$DISKIMG
fi

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

if [ -z $IMGTPL ]; then

sudo mmdebstrap \
	--hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
	--include=$INCPKGS \
	--skip=check/empty \
	--architectures=$TARGET_ARCH $COMPONENTS \
	$ROOTFS \
	"${INCREPOS[@]}"

fi
