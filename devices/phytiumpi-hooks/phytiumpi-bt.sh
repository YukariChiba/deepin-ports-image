#!/bin/bash

sudo cp ./devices/phytiumpi-hooks/phytiumpi-bt/rtk_hciattach_arm64 $ROOTFS/usr/bin/rtk_hciattach
sudo chmod 755 $ROOTFS/usr/bin/rtk_hciattach
sudo rm -r $ROOTFS/lib/firmware/rtlbt/*
sudo cp ./devices/phytiumpi-hooks/phytiumpi-bt/rtl882* $ROOTFS/lib/firmware/rtlbt/
sudo cp ./devices/phytiumpi-hooks/phytiumpi-bt/bt-init.service $ROOTFS/lib/systemd/system/bt-init.service
sudo cp ./devices/phytiumpi-hooks/phytiumpi-bt/bt_init $ROOTFS/usr/bin/bt_init
sudo chmod 755 $ROOTFS/usr/bin/bt_init
sudo ln -s $ROOTFS/lib/systemd/system/bt-init.service $ROOTFS/etc/systemd/system/multi-user.target.wants/bt-init.service
