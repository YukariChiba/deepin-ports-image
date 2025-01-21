#!/bin/bash

### Check arguments

TARGET_DEVICE_CONF=${1:-generic}

if [ ! -f "./devices/$TARGET_DEVICE_CONF" ]; then
  echo error: device $TARGET_DEVICE_CONF config not found
  exit 1
fi

### Setup binfmt

sudo systemctl restart systemd-binfmt
sleep 1

### Read and set config

. ./utils/defaults.sh
. ./devices/$TARGET_DEVICE_CONF

ROOTFS=`mktemp -d ./tmp/tmp.XXXXXX`
IMGPFX="deepin-$TARGET_DEVICE-$TARGET_ARCH-$REPOPROFILE-$PKGPROFILE"

### Install system

if [ "$FSFMT" != "tarball" ]; then
  . ./utils/mount.sh
fi
. ./utils/install.sh
. ./utils/hooks.sh

### Collect results

mkdir -p results-img
if [ "$FSFMT" != "tarball" ]; then
  . ./utils/cleanup.sh
  if [ ! -z $IMGPROFILE ] && command -v genimage &> /dev/null; then
    . ./utils/genimage.sh
  else
    mv ./results/$IMGPFX.* ./results-img/
  fi
else
  echo waiting for mounpoint release
  sleep 5
  sudo tar -C $ROOTFS -czvf results-img/$IMGPFX.tar.gz .
fi

### Generate checksum

pushd results-img
for checksum in sha256sum md5sum; do
  $checksum $IMGPFX.* > $IMGPFX-$checksum
done
for checksum in sha256sum md5sum; do
  mv $IMGPFX-$checksum $IMGPFX.$checksum
done
popd

### Compress files

if [ ! -z $COMPRESS ]; then
  export XZ_OPT='-T0'
  pushd results-img
  tar cJvf \
    deepin-$REPOPROFILE-beige-preview-$TARGET_ARCH-$TARGET_DEVICE-$(date "+%Y%m%d")-$(date "+%H%M%S").tar.xz \
    ./$IMGPFX.* 
  popd
fi
