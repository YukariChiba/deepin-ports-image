#!/bin/bash

# phytium pi: MBR
if [ "$TARGET_DEVICE" != "phytiumpi" ]; then
  sudo mkdir -p $ROOTFS/etc/repart.d
  cat <<EOF | sudo tee $ROOTFS/etc/repart.d/growroot.conf
[Partition]
Type=linux-generic
GrowFileSystem=true
EOF

fi
