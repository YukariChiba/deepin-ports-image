#!/bin/bash

if [ "$TARGET_DEVICE" == "p1" ]; then

cat <<EOF | sudo tee $ROOTFS/etc/X11/xorg.conf.d/99-imggpu.conf > /dev/null
Section "Device"
        Identifier "imggpu"
        Driver "pvrdri"
	Option "UseGammaLUT" "false"
        Option "kmsdev" "/dev/dri/card0"
EndSection
EOF

else

cat <<EOF | sudo tee $ROOTFS/etc/X11/xorg.conf.d/99-imggpu.conf > /dev/null
Section "Device"
        Identifier "imggpu"
        Driver "thead"
        Option "kmsdev" "/dev/dri/card0"
EndSection
EOF

fi
