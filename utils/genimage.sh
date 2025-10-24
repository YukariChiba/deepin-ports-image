#!/bin/bash

if [ ! -z $IMGPROFILE ]; then
  if [ -f ./genimage/$IMGPROFILE.cfg ]; then
    GENIMGCFG=`mktemp ./tmp/tmp.genimage.XXXXXX`
    GENIMGTMP=`mktemp -d ./tmp/tmp.genimage.XXXXXX`
    cp ./genimage/$IMGPROFILE.cfg $GENIMGCFG
    sed -i "s@%blpfx%@injectbin/bootloader/$TARGET_DEVICE@" $GENIMGCFG
    sed -i "s@%image%@$IMGPFX.img@" $GENIMGCFG
    sed -i "s@%boot%@$BOOTIMG@" $GENIMGCFG
    sed -i "s@%root%@$DISKIMG@" $GENIMGCFG
    sed -i "s@%efi%@$EFIIMG@" $GENIMGCFG
    sed -i "s@%extra%@$IMGEXTRA@" $GENIMGCFG
    genimage --config $GENIMGCFG \
      --inputpath . \
      --tmppath $GENIMGTMP \
      --outputpath results-img
  else
    echo "err: genimage profile not found"
    exit 1
  fi
fi
