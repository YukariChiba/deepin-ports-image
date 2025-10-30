#!/bin/bash

. ./profiles/device_repo.sh

INCREPOS=("${INCREPOS[@]}" "$INCREPOS_DEV")

if [ -z $INTERNAL_REPO ]; then
  echo "$INCREPOS_DEV" | sudo tee -a $ROOTFS/etc/apt/sources.list > /dev/null
else
  echo "$INCREPOS_INTERNAL_DEV" | sudo tee -a $ROOTFS/etc/apt/sources.list > /dev/null
fi

if [ ! -z $EXTRAPKGS ]; then
  sudo systemd-nspawn -D $ROOTFS bash -c "export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y full-upgrade && apt-get -y install ${EXTRAPKGS//,/ }"
fi

sudo systemd-nspawn -D $ROOTFS bash -c "apt clean"
