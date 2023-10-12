#!/usr/bin/bash

rm $0

mount -t proc /proc proc
resize2fs /dev/mmcblk0p3
umount /proc

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cat << 'EOF' >> /etc/apt/apt.conf.d/99-kernel-hook
DPkg::Pre-Install-Pkgs {"/usr/local/bin/apt-hook-install-kernel";};
DPkg::Tools::Options::/usr/local/bin/apt-hook-install-kernel::Version "1";
EOF

cat << 'EOF' >> /usr/local/bin/apt-hook-install-kernel
#! /bin/bash

if grep -q linux-image-
then
	cp /boot/vmlinux* /boot/Image
fi
EOF

chmod +x /usr/local/bin/apt-hook-install-kernel

dpkg -i /debootstrap/linux-image.deb

echo "deb [trusted=yes] https://mirror.iscas.ac.cn/revyos/revyos-kernels/ revyos-kernels main" >> /etc/apt/sources.list

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
parted -s /dev/mmcblk0 "resizepart 3 -0"
resize2fs /dev/mmcblk0p3
resize2fs /dev/mmcblk0p2
umount /proc

useradd -m deepin
usermod -G sudo deepin

chsh -s /bin/bash deepin

echo root:deepin | chpasswd
echo deepin:deepin | chpasswd

rm -rf /boot/*

echo "/dev/mmcblk0p2 /boot ext4 defaults" > /etc/fstab

echo "Install complete, entering system..." > /dev/tty0

sleep 3

exec /lib/systemd/systemd
