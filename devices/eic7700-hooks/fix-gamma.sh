#!/bin/bash

if [ ! -z $IMGGPU ]; then
  echo "--- Fix gamma"
  cat <<EOF | sudo tee $ROOTFS/etc/X11/xorg.conf.d/98-gamma.conf
Section "Monitor"
    Identifier "Monitor0"
    Gamma 0.5 0.5 0.5
EndSection

Section "Screen"
    Identifier "Screen0"
    Device "Device0"
    Monitor "Monitor0"
EndSection
EOF
fi
