#!/bin/bash

sudo cp ./devices/rvbook-hooks/bt/rtk_hciattach $ROOTFS/usr/bin/rtk_hciattach
sudo chmod 755 $ROOTFS/usr/bin/rtk_hciattach
sudo cp ./devices/rvbook-hooks/bt/rtl8* $ROOTFS/lib/firmware/rtlbt/
sudo cp ./devices/rvbook-hooks/bt/light-bt.service $ROOTFS/lib/systemd/system/bt-init.service
sudo cp ./devices/rvbook-hooks/bt/bt-init $ROOTFS/usr/bin/bt-init
sudo chmod 755 $ROOTFS/usr/bin/bt-init
sudo ln -s $ROOTFS/lib/systemd/system/bt-init.service $ROOTFS/etc/systemd/system/multi-user.target.wants/bt-init.service
