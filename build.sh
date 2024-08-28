#!/bin/bash

TARGET_DEVICE_CONF=${1:-generic}

if [ ! -f "./devices/$TARGET_DEVICE_CONF" ]; then
  echo error: device $TARGET_DEVICE_CONF config not found
  exit 1
fi

sudo systemctl restart systemd-binfmt
sleep 1

. ./utils/defaults.sh
. ./devices/$TARGET_DEVICE_CONF
if [ "$FSFMT" == "sfs" ]; then
  . ./utils/mount-sfs.sh
else
  . ./utils/mount.sh
fi
. ./utils/install.sh
. ./utils/hooks.sh
if [ "$FSFMT" == "sfs" ]; then
  . ./utils/cleanup-sfs.sh
else
  . ./utils/cleanup.sh
fi
if command -v genimage &> /dev/null; then
  . ./utils/genimage.sh
fi
pushd results-img
for checksum in sha256sum md5sum; do
  $checksum deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE.* > deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE.$checksum
done
popd
if [ ! -z $COMPRESS ]; then
  export XZ_OPT='-T0'
  pushd results-img
  tar cJvf \
    deepin-23-beige-preview-$TARGET_ARCH-$TARGET_DEVICE-$(date "+%Y%m%d")-$(date "+%H%M%S").tar.xz \
    ./deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE.* 
  popd
fi
