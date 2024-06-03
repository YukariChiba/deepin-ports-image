#!/bin/bash

TARGET_DEVICE=milkv-mars
TARGET_ARCH=riscv64
REPOPROFILE=stable
PKGPROFILE=desktop
IMGPROFILE=generic
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE"
BOOTIMG=deepin-milkv-mars-riscv64-stable-desktop-installer.boot.fat32
DISKIMG=deepin-milkv-mars-riscv64-stable-desktop-installer.root.ext4

if [ ! -z $IMGPROFILE ]; then
  if [ -f ./genimage/$IMGPROFILE.cfg ]; then
    GENIMGCFG=`mktemp ./tmp/tmp.genimage.XXXXXX`
    GENIMGTMP=`mktemp -d ./tmp/tmp.genimage.XXXXXX`
    cp ./genimage/$IMGPROFILE.cfg $GENIMGCFG
    sed -i "s@%blpfx%@../injectbin/bootloader/$TARGET_DEVICE@" $GENIMGCFG
    sed -i "s/%image%/$IMGPFX.img/" $GENIMGCFG
    sed -i "s/%boot%/$BOOTIMG/" $GENIMGCFG
    sed -i "s/%root%/$DISKIMG/" $GENIMGCFG
    GENIMGINC="--inputpath results"
    if [ -d ./injectbin/bootloader/$TARGET_DEVICE ]; then
      GENIMGINC+=" --includepath ./injectbin/bootloader/$TARGET_DEVICE"
    fi
    genimage --config $GENIMGCFG \
      $GENIMGINC \
      --tmppath $GENIMGTMP \
      --outputpath results
  else
    echo "err: genimage profile not found"
    exit 1
  fi
fi
