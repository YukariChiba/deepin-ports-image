#!/bin/bash

sudo mkdir -p $ROOTFS/etc/repart.d

cat <<EOF | sudo tee $ROOTFS/etc/repart.d/growroot.conf
[Partition]
Type=root
EOF
