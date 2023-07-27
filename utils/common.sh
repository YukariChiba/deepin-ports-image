#!/bin/bash

ROOTFS=`mktemp -d`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH"
DISKIMG="$IMGPFX.root.$FSFMT"
BOOTIMG="$IMGPFX.boot.$BOOTFMT"

rm ./*.noconf.$FSFMT

mkdir -p $CACHEPATH

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
sudo mkfs.$FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

sudo debootstrap --arch=$TARGET_ARCH --foreign \
        --no-check-gpg \
        --include=$INCPKGS \
        --cache-dir=$CACHEPATH \
        beige \
        $ROOTFS \
        $REPO

sudo echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee $ROOTFS/etc/hostname > /dev/null

sudo echo "deb [trusted=yes] $REPO beige main" | sudo tee $ROOTFS/etc/apt/sources.list > /dev/null

sudo cp ./stage2/$TARGET_DEVICE.sh $ROOTFS/lib/systemd/systemd
sudo chmod +x $ROOTFS/lib/systemd/systemd

if [ "$BUILDBOOTIMG" -eq "1" ]; then
	dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE
	sudo mkfs.$BOOTFMT ./$BOOTIMG
	sudo mkdir -p $ROOTFS/boot
	sudo mount ./$BOOTIMG $ROOTFS/boot

	KERNELDIR=`mktemp -d`

	sudo dpkg-deb -x linux-image.deb $KERNELDIR

	sudo cp $KERNELDIR/boot/vmlinux* $ROOTFS/boot/Image
	sudo cp $KERNELDIR/usr/lib/linux-image-*/$DTBPATH $ROOTFS/boot/
	sudo cp ./bootbin/$TARGET_DEVICE/* $ROOTFS/boot/

	sudo cp linux-image.deb $ROOTFS/debootstrap/
fi

