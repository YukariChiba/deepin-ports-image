#!/bin/bash

if [ -f $ROOTFS/usr/bin/ll-cli ]; then
  cat $ROOTFS/etc/packages.linglong.* | grep -v '#' | sudo tee $ROOTFS/tmp/ll.list
  sudo systemd-nspawn -D $ROOTFS bash -c "xargs -n1 --arg-file=/tmp/ll.list ll-cli --no-dbus install"
fi
