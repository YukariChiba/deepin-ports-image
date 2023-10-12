#!/usr/bin/bash

rm /sbin/init

mount -t proc /proc proc
resize2fs /dev/mmcblk0p2
umount /proc

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cat << 'EOF' >> /dev/tty0
      _                 _                              _
   __| | ___  ___ _ __ (_)_ __        _ __   ___  _ __| |_ ___
  / _` |/ _ \/ _ \ '_ \| | '_ \ _____| '_ \ / _ \| '__| __/ __|
 | (_| |  __/  __/ |_) | | | | |_____| |_) | (_) | |  | |_\__ \
  \__,_|\___|\___| .__/|_|_| |_|     | .__/ \___/|_|   \__|___/
                 |_|                 |_|

EOF

echo "Performing second-stage installation, please wait..." > /dev/tty0

/debootstrap/debootstrap --second-stage | tee /dev/tty0

mount -t proc /proc proc
parted -s /dev/mmcblk0 "resizepart 2 -0"
resize2fs /dev/mmcblk0p2
umount /proc

useradd -m deepin
usermod -G sudo deepin

chsh -s /bin/bash deepin

echo root:deepin | chpasswd
echo deepin:deepin | chpasswd

rm -rf /boot/*

echo "Install complete, entering system..." > /dev/tty0

sleep 3

exec /lib/systemd/systemd
