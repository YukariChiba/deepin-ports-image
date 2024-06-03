#!/bin/bash

mkdir -p results-img

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
      --outputpath results-img
  else
    echo "err: genimage profile not found"
    exit 1
  fi
else
  mv ./results/$IMGPFX.* ./results-img/
fi
