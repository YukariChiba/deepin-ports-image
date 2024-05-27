#!/bin/bash

if [ ! -z $IMGGPU ]; then
  cat <<EOF | sudo tee $ROOTFS/etc/X11/xorg.conf.d/99-imggpu.conf
Section "Device"
        Identifier "imggpu"
        Driver "pvrdri"
        Option "kmsdev" "/dev/dri/card1"
EndSection
EOF
fi
