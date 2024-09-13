#!/bin/bash

sudo cp ./devices/k1-hooks/musebox-bt/bt-init.service $ROOTFS/lib/systemd/system/bt-init.service
sudo cp ./devices/k1-hooks/musebox-bt/realtek_bt.sh $ROOTFS/usr/bin/realtek_bt.sh
sudo chmod 755 $ROOTFS/usr/bin/realtek_bt.sh
sudo ln -s $ROOTFS/lib/systemd/system/bt-init.service $ROOTFS/etc/systemd/system/multi-user.target.wants/bt-init.service
