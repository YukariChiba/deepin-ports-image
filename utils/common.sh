#!/bin/bash

ROOTFS=`mktemp -d`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$IMGPROFILE"
DISKIMG="$IMGPFX.root.$FSFMT"
BOOTIMG="$IMGPFX.boot.$BOOTFMT"

if [ ! -f "./packages.$IMGPROFILE.txt" ]; then
	echo "error: packages list of profile '$IMGPROFILE' not found"
	exit 1
fi

INCPKGS=`cat ./packages.$IMGPROFILE.txt | xargs | sed -e 's/ /,/g'`

mkdir -p $CACHEPATH

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
sudo mkfs.$FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

sudo debootstrap --arch=$TARGET_ARCH --foreign \
        --no-check-gpg \
        --include=$INCPKGS \
        --cache-dir=$CACHEPATH \
	--components=$COMPONENTS \
        beige \
        $ROOTFS \
        $REPO

sudo echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee $ROOTFS/etc/hostname > /dev/null
sudo echo "Asia/Shanghai" | sudo tee $ROOTFS/etc/timezone > /dev/null
sudo ln -s /usr/share/zoneinfo/Asia/Shanghai $ROOTFS/etc/localtime

sudo echo "deb [trusted=yes] $REPO beige main" | sudo tee $ROOTFS/etc/apt/sources.list > /dev/null

sudo cp ./stage2/$TARGET_DEVICE.sh $ROOTFS/$INITEXEC
sudo chmod +x $ROOTFS/$INITEXEC

if [ -d "./injectbin/firmware/$TARGET_DEVICE" ]; then
	sudo mkdir -p $ROOTFS/lib/firmware
	sudo cp -r ./injectbin/firmware/$TARGET_DEVICE/* $ROOTFS/lib/firmware/
fi

if [ -d "./injectbin/modules/$TARGET_DEVICE" ]; then
	sudo mkdir -p $ROOTFS/lib/modules
	sudo cp -r ./injectbin/modules/$TARGET_DEVICE/* $ROOTFS/lib/modules/
fi

if [ -d "./injectbin/bin/$TARGET_DEVICE" ]; then
	sudo mkdir -p $ROOTFS/usr/bin
	sudo cp -r ./injectbin/bin/$TARGET_DEVICE/* $ROOTFS/usr/bin/
fi

if [ -d "./injectbin/services/$TARGET_DEVICE" ]; then
	sudo mkdir -p $ROOTFS/lib/systemd/system
	sudo cp -r ./injectbin/services/$TARGET_DEVICE/* $ROOTFS/lib/systemd/system/
fi

if [ "$BUILDBOOTIMG" -eq "1" ]; then
	dd if=/dev/zero of=./$BOOTIMG iflag=fullblock bs=1M count=$BOOTSIZE
	sudo mkfs.$BOOTFMT ./$BOOTIMG
	sudo mkdir -p $ROOTFS/boot
	sudo mount ./$BOOTIMG $ROOTFS/boot

	KERNELDIR=`mktemp -d`

	if [ -d "./injectbin/kerneldeb/$TARGET_DEVICE/linux-image.deb" ]; then
		sudo dpkg-deb -x ./injectbin/kerneldeb/$TARGET_DEVICE/linux-image.deb $KERNELDIR
		sudo cp $KERNELDIR/boot/vmlinux* $ROOTFS/boot/Image
		sudo cp $KERNELDIR/usr/lib/linux-image-*/$DTBPATH $ROOTFS/boot/
		sudo cp ./injectbin/kerneldeb/$TARGET_DEVICE/linux-image.deb $ROOTFS/debootstrap/
	fi

	if [ -d "./bootbin/$TARGET_DEVICE" ]; then
	       sudo cp ./bootbin/$TARGET_DEVICE/* $ROOTFS/boot/
	fi
fi
