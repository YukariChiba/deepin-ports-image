#!/bin/bash

if [ "$FSFNT" != "tarball" ]; then

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

if [ "$EFISIZE" -ne "0" ]; then
  cat <<EOF | sudo tee -a $ROOTFS/etc/fstab
LABEL=efi /boot/efi vfat defaults 0 0
EOF
fi

cat <<EOF | sudo tee -a $ROOTFS/etc/fstab
PARTLABEL=swap swap swap defaults,nofail,x-systemd.makefs,x-systemd.device-timeout=3s 0 0
EOF

fi
