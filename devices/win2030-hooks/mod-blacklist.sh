#!/bin/bash

echo "blacklist evbug" | sudo tee $ROOTFS/etc/modprobe.d/evbug.conf

if [[ ${INCPKGS[@]} =~ initramfs-tools ]]; then
  echo "--- Update initramfs"
  sudo systemd-nspawn -D $ROOTFS bash -c "update-initramfs -k all -c || true"
fi

