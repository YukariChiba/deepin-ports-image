#!/bin/bash

echo "blacklist smifb" | sudo tee $ROOTFS/etc/modprobe.d/sg2042-extgpu.conf

if [[ ${INCPKGS[@]} =~ initramfs-tools ]]; then
  echo "--- Update initramfs"
  sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
fi

