#!/bin/bash

cat <<EOF | sudo tee $ROOTFS/etc/product-info
Deepin OS-23-$(date "+%Y%m%d%H%M%S")00-1_$TARGET_ARCH
EOF

