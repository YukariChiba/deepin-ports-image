#!/bin/bash

if [ ! -z $IMGGPU ]; then
  cat <<EOF | sudo tee $ROOTFS/etc/X11/xorg.conf.d/99-imggpu.conf > /dev/null
Section "Device"
        Identifier "imggpu"
        Driver "pvrdri"
        Option "kmsdev" "/dev/dri/card0"
	Option "SWcursor" true
EndSection
EOF
fi
