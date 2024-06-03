#!/bin/bash

if [ -z $NOGROWROOT ]; then
  cat <<EOF | sudo tee -a $ROOTFS/etc/fstab
LABEL=root / ext4 defaults,rw,errors=remount-ro,x-systemd.growfs 0 0
EOF
fi

if [ "$TARGET_DEVICE" == "romadc" ]; then
  cat <<EOF | sudo tee -a $ROOTFS/etc/fstab
/dev/mmcblk1p3 /boot vfat defaults 0 0
EOF
fi

if [ "$BOOTFMT" == "ext4" ] && [ "$BOOTSIZE" -ne "0" ]; then
  cat <<EOF | sudo tee -a $ROOTFS/etc/fstab
LABEL=boot /boot ext4 defaults 0 0
EOF
fi
