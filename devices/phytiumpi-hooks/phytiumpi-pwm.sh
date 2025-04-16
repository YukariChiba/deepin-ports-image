#!/bin/bash

sudo cp ./devices/phytiumpi-hooks/phytiumpi-pwm/phytiumpi-pwm.sh $ROOTFS/usr/bin/phytiumpi-pwm
sudo cp ./devices/phytiumpi-hooks/phytiumpi-pwm/pwm-init.service $ROOTFS/lib/systemd/system/pwm-init.service
sudo chmod 755 $ROOTFS/usr/bin/phytiumpi-pwm
sudo ln -s $ROOTFS/lib/systemd/system/pwm-init.service $ROOTFS/etc/systemd/system/multi-user.target.wants/pwm-init.service
