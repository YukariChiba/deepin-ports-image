#!/bin/bash

FSFMT=ext4
BOOTFMT=ext4
TARGET_DEVICE=lpi4a
TARGET_ARCH=riscv64
DISKSIZE=1024
BOOTSIZE=40
CACHEPATH=`pwd`/cache
REPO="https://ci.deepin.com/repo/deepin/deepin-ports/deepin-stage1/"
DTBPATH=thead/light-lpi4a.dtb

#------------------------------------------------------------------------

ROOTFS=`mktemp -d`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-`date "+%F-%H-%M"`"
DISKIMG="$IMGPFX.root.noconf.$FSFMT"
BOOTIMG="$IMGPFX.boot.noconf.$BOOTFMT"

rm ./*.noconf.$FSFMT

mkdir -p $CACHEPATH

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE

sudo mkfs.ext4 ./$DISKIMG
sudo mkfs.ext4 ./$BOOTIMG

sudo mount ./$DISKIMG $ROOTFS
sudo mkdir $ROOTFS/boot
sudo mount ./$BOOTIMG $ROOTFS/boot

sudo debootstrap --arch=$TARGET_ARCH --foreign \
	--no-check-gpg \
	--include=parted \
	--cache-dir=$CACHEPATH \
	beige \
       	$ROOTFS \
	$REPO

sudo echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee $ROOTFS/etc/hostname > /dev/null

sudo echo "deb [trusted=yes] $REPO beige main" | sudo tee $ROOTFS/etc/apt/sources.list > /dev/null

sudo cp ./init-conf.sh $ROOTFS/lib/systemd/systemd
sudo chmod +x $ROOTFS/lib/systemd/systemd

KERNELDIR=`mktemp -d`

sudo dpkg-deb -x linux-image.deb $KERNELDIR

sudo cp -r $KERNELDIR/lib/modules $ROOTFS/lib/modules

sudo cp $KERNELDIR/boot/vmlinux* $ROOTFS/boot/Image
sudo cp $KERNELDIR/usr/lib/linux-image-*/$DTBPATH $ROOTFS/boot/
sudo cp ./bootbin/* $ROOTFS/boot/

sudo umount $ROOTFS/boot
sudo umount $ROOTFS

sudo fastboot flash boot ./$BOOTIMG
sudo fastboot flash root ./$DISKIMG
