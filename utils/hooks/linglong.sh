#!/bin/bash

if [ -f $ROOTFS/usr/bin/ll-cli ]; then

  if [ ! -z $INTERNAL_REPO ]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "ll-cli --no-dbus repo update stable https://repo-dev.cicd.getdeepin.org"
  fi

  cat $ROOTFS/etc/packages.linglong.* | grep -v '#' | sudo tee $ROOTFS/etc/packages.linglong
  sudo systemd-nspawn -D $ROOTFS bash -c "xargs -n1 --arg-file=/etc/packages.linglong ll-cli --no-dbus install"

  if [ ! -z $INTERNAL_REPO ]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "ll-cli --no-dbus repo update stable https://mirror-repo-linglong.deepin.com"
  fi
fi
