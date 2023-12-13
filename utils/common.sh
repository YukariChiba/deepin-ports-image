#!/bin/bash

ROOTFS=`mktemp -d`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE"
DISKIMG="$IMGPFX.root.$FSFMT"
BOOTIMG="$IMGPFX.boot.$BOOTFMT"

if [ ! -f "./profiles/repos.$REPOPROFILE.txt" ]; then
	echo "error: repo list of profile '$REPOPROFILE' not found"
	exit 1
fi

if [ ! -f "./profiles/packages.$PKGPROFILE.txt" ]; then
	echo "error: packages list of profile '$PKGPROFILE' not found"
	exit 1
fi

readarray -t INCREPOS < ./profiles/repos.$REPOPROFILE.txt
INCPKGS=`cat ./profiles/packages.$PKGPROFILE.txt | grep -v "^-" | xargs | sed -e 's/ /,/g'`

if [ -e "./$DISKIMG" ]; then
	rm ./$DISKIMG
fi

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
sudo mkfs.$FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

sudo mmdebstrap \
	--hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
	--include=$INCPKGS \
	--architectures=$TARGET_ARCH $COMPONENTS \
	--customize=./utils/stage2.sh \
	$ROOTFS \
	"${INCREPOS[@]}"

sudo echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee $ROOTFS/etc/hostname > /dev/null
sudo echo "Asia/Shanghai" | sudo tee $ROOTFS/etc/timezone > /dev/null
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai $ROOTFS/etc/localtime

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
	sudo mkdir -p $ROOTFS/boot
	sudo mount ./$BOOTIMG $ROOTFS/boot
fi

if [ -d "./bootbin/$TARGET_DEVICE" ]; then
       sudo cp -r ./bootbin/$TARGET_DEVICE/* $ROOTFS/boot/
fi
