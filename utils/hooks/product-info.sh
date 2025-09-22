#!/bin/bash

cat <<EOF | sudo tee $ROOTFS/etc/product-info > /dev/null
$(cat $ROOTFS/etc/os-version  | grep "SystemName=")
$(cat $ROOTFS/etc/os-version  | grep "EditionName=")
$(cat $ROOTFS/etc/os-version  | grep "MajorVersion=")
$(cat $ROOTFS/etc/os-version  | grep "MinorVersion=")
ProductName=Community
BuildTime=$(TZ="Asia/Shanghai" date +%Y%m%d%H%M%S)
Arch=$TARGET_ARCH
OEM=
EOF

