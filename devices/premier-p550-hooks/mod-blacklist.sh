#!/bin/bash

echo "install realtek /bin/true" | sudo tee $ROOTFS/etc/modprobe.d/fix-eth.conf

if [[ ${INCPKGS[@]} =~ initramfs-tools ]]; then
  echo "--- Update initramfs"
  sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
fi

