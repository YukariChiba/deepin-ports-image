#!/bin/bash

sudo cp ./devices/$TARGET_DEVICE-hooks/bt/rtk_hciattach $ROOTFS/usr/bin/rtk_hciattach
sudo chmod 755 $ROOTFS/usr/bin/rtk_hciattach
sudo cp ./devices/$TARGET_DEVICE-hooks/bt/rtl8* $ROOTFS/lib/firmware/rtlbt/
sudo cp ./devices/$TARGET_DEVICE-hooks/bt/light-bt.service $ROOTFS/lib/systemd/system/bt-init.service
if [ "$TARGET_DEVICE" == "rvbook" ]; then
  sudo cp ./devices/$TARGET_DEVICE-hooks/bt/bt-init-zhihe $ROOTFS/usr/bin/bt-init
else
  sudo cp ./devices/$TARGET_DEVICE-hooks/bt/bt-init $ROOTFS/usr/bin/bt-init
fi
sudo chmod 755 $ROOTFS/usr/bin/bt-init
sudo ln -s $ROOTFS/lib/systemd/system/bt-init.service $ROOTFS/etc/systemd/system/multi-user.target.wants/bt-init.service
