#!/bin/bash

cat <<EOF | sudo tee $ROOTFS/etc/X11/xorg.conf.d/99-imggpu.conf > /dev/null
Section "Device"
        Identifier "imggpu"
        Driver "thead"
        Option "kmsdev" "/dev/dri/card0"
EndSection
EOF
