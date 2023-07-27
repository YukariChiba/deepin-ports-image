#!/bin/bash

FSFMT=ext4
BOOTFMT=ext4
TARGET_DEVICE=lpi4a
TARGET_ARCH=riscv64
DISKSIZE=6000
BOOTSIZE=60
KERNELSRC=https://github.com/revyos/thead-kernel/suites/14568830941/artifacts/824963725
CACHEPATH=`pwd`/cache

#------------------------------------------------------------------------

IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-`date "+%F-%H-%M"`"
DISKIMG="$IMGPFX.root.$FSFMT"
BOOTIMG="$IMGPFX.boot.$BOOTFMT"

rm ./*.$FSFMT

mkdir -p rootfs
#mkdir -p bootfs
mkdir -p $CACHEPATH

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
#dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE

sudo mkfs.ext4 ./$DISKIMG
#sudo mkfs.ext4 ./$BOOTIMG

sudo mount ./$DISKIMG ./rootfs
#sudo mkdir ./rootfs/boot
#sudo mount ./$BOOTIMG ./rootfs/boot

sudo debootstrap --arch=$TARGET_ARCH --foreign \
	--no-check-gpg \
	--include=`cat ./packages.txt | xargs | sed -e 's/ /,/g'` \
	--cache-dir=$CACHEPATH \
	beige \
       	rootfs \
	"https://ci.deepin.com/repo/deepin/deepin-ports/deepin-port-stage1/"

sudo echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee ./rootfs/etc/hostname > /dev/null

sudo cp ./sources.list ./rootfs/etc/apt/sources.list

#wget "$KERNELSRC" -O kernel.tar.gz

sudo cp "$(which qemu-$TARGET_ARCH-static)" ./rootfs/usr/bin

sudo chroot rootfs /debootstrap/debootstrap --second-stage

#sudo umount ./rootfs/boot
#sudo umount ./rootfs
