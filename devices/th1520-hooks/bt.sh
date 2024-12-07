#!/bin/bash

pfx=bt

if [ "$TARGET_DEVICE" == "p1" ]; then
  pfx=bt-zhihe
fi

sudo cp ./devices/$TARGET_DEVICE-hooks/$pfx/rtk_hciattach $ROOTFS/usr/bin/rtk_hciattach
sudo chmod 755 $ROOTFS/usr/bin/rtk_hciattach
sudo cp ./devices/$TARGET_DEVICE-hooks/$pfx/rtl8* $ROOTFS/lib/firmware/rtlbt/
sudo cp ./devices/$TARGET_DEVICE-hooks/$pfx/bt-init.service $ROOTFS/lib/systemd/system/bt-init.service
sudo cp ./devices/$TARGET_DEVICE-hooks/$pfx/bt-init $ROOTFS/usr/bin/bt-init
sudo chmod 755 $ROOTFS/usr/bin/bt-init
sudo ln -s $ROOTFS/lib/systemd/system/bt-init.service $ROOTFS/etc/systemd/system/multi-user.target.wants/bt-init.service