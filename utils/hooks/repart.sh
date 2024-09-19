#!/bin/bash

if [ -z $NOREPARTROOT ] && [ "$FSFMT" != "tarball" ]; then
  sudo mkdir -p $ROOTFS/etc/repart.d
  cat <<EOF | sudo tee $ROOTFS/etc/repart.d/growroot.conf
[Partition]
Type=linux-generic
GrowFileSystem=true
EOF

fi
