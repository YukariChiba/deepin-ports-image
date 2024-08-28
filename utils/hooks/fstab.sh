#!/bin/bash

if [ -z $NOGROWROOT ]; then
  cat <<EOF | sudo tee -a $ROOTFS/etc/fstab
LABEL=root / ext4 defaults,rw,errors=remount-ro,x-systemd.growfs 0 0
EOF
fi

if [ "$BOOTSIZE" -ne "0" ]; then
  cat <<EOF | sudo tee -a $ROOTFS/etc/fstab
LABEL=boot /boot auto defaults 0 0
EOF
fi
