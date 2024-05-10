#!/bin/bash

if [ "$BOOTFMT" == "ext4" ] && [ "$BOOTSIZE" -ne "0" ]; then
cat <<EOF | sudo tee $ROOTFS/etc/fstab > /dev/null
LABEL=boot /boot ext4 defaults 0 2
EOF
fi
