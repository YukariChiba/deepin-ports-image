#!/bin/bash

if [ -z $NOGROWROOT ]; then
sudo mkdir -p $ROOTFS/etc/repart.d/
cat <<EOF | sudo tee $ROOTFS/etc/repart.d/resize-root.conf > /dev/null
[Partition]
Type=root
EOF
fi
