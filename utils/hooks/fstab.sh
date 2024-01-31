#!/bin/bash

if [ "$TARGET_DEVICE" == "romadc" ]; then
  cat <<EOF | sudo tee $ROOTFS/etc/fstab
/dev/mmcblk1p3 /boot vfat defaults 0 0
EOF
fi

if [ "$TARGET_DEVICE" == "lpi4a" ]; then
  cat <<EOF | sudo tee $ROOTFS/etc/fstab
LABEL=boot /boot ext4 defaults 0 0
EOF
fi
