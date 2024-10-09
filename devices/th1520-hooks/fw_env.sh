#!/bin/bash

cat <<EOF | sudo tee $ROOTFS/etc/fw_env.config > /dev/null
/dev/mmcblk0 0xe0000 0x20000
EOF
