#!/bin/bash

ROOTFS=`mktemp -d`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$IMGPROFILE"
DISKIMG="$IMGPFX.root.$FSFMT"
BOOTIMG="$IMGPFX.boot.$BOOTFMT"

if [ ! -f "./packages.$IMGPROFILE.txt" ]; then
	echo "error: packages list of profile '$IMGPROFILE' not found"
	exit 1
fi

INCPKGS=`cat ./packages.$IMGPROFILE.txt | grep -v "^-" | xargs | sed -e 's/ /,/g'`
EXCPKGS=`cat ./packages.$IMGPROFILE.txt | grep "^-" | sed 's/^-//g' | xargs | sed -e 's/ /,/g'`

mkdir -p $CACHEPATH

if [ -e "./$DISKIMG" ]; then
	rm ./$DISKIMG
fi

dd if=/dev/zero of=./$DISKIMG iflag=fullblock bs=1M count=$DISKSIZE
sudo mkfs.$FSFMT ./$DISKIMG

sudo mount ./$DISKIMG $ROOTFS

if [ "$BOOTSTRAP_ENGINE" == "mmdebstrap" ]; then
	sudo mmdebstrap \
        	--mode=root \
        	--include=$INCPKGS \
        	--architectures=$TARGET_ARCH standard \
		--customize=./stage2/mmdebstrap.sh \
        	$ROOTFS \
        	"deb [trusted=yes] https://ci.deepin.com/repo/obs/deepin%3A/Develop%3A/main/standard/ ./" \
        	"deb [trusted=yes] https://ci.deepin.com/repo/obs/deepin%3A/Develop%3A/main%3A/bootstrap/bootstrap-riscv64/ ./" \
        	"deb [trusted=yes] https://ci.deepin.com/repo/obs/deepin%3A/Develop%3A/community/deepin_develop/ ./" \
        	"deb [trusted=yes] https://ci.deepin.com/repo/obs/deepin%3A/Develop%3A/dde/deepin_develop/ ./"
else
	INCEXC=""
	if [ "$INCPKGS" != "" ]; then
		INCEXC+=" --include=$INCPKGS "
	fi
	if [ "$EXCPKGS" != "" ]; then
		INCEXC+=" --exclude=$EXCPKGS "
	fi
	sudo debootstrap --arch=$TARGET_ARCH --foreign \
        	--no-check-gpg \
        	--cache-dir=$CACHEPATH \
		--components=$COMPONENTS \
		$INCEXC \
        	beige \
        	$ROOTFS \
        	$REPO
	sudo echo "deb [trusted=yes] $REPO beige main" | sudo tee $ROOTFS/etc/apt/sources.list > /dev/null
fi

sudo echo "deepin-$TARGET_ARCH-$TARGET_DEVICE" | sudo tee $ROOTFS/etc/hostname > /dev/null
sudo echo "Asia/Shanghai" | sudo tee $ROOTFS/etc/timezone > /dev/null
sudo ln -s /usr/share/zoneinfo/Asia/Shanghai $ROOTFS/etc/localtime

if [ "$INITEXEC" != "" ]; then
	sudo cp ./stage2/$TARGET_DEVICE.sh $ROOTFS/$INITEXEC
	sudo chmod +x $ROOTFS/$INITEXEC
fi

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

	KERNELDIR=`mktemp -d`

	if [ -d "./injectbin/kerneldeb/$TARGET_DEVICE/linux-image.deb" ]; then
		sudo dpkg-deb -x ./injectbin/kerneldeb/$TARGET_DEVICE/linux-image.deb $KERNELDIR
		sudo cp $KERNELDIR/boot/vmlinux* $ROOTFS/boot/Image
		sudo cp $KERNELDIR/usr/lib/linux-image-*/$DTBPATH $ROOTFS/boot/
		sudo cp ./injectbin/kerneldeb/$TARGET_DEVICE/linux-image.deb $ROOTFS/debootstrap/
	fi
fi

if [ -d "./bootbin/$TARGET_DEVICE" ]; then
       sudo cp -r ./bootbin/$TARGET_DEVICE/* $ROOTFS/boot/
fi
