#!/bin/bash

if [ ! -z $IMGGPU ]; then
  IMGGPU_DISP_DEV=${IMGGPU_DISP_DEV:-/dev/dri/card1}
  cat <<EOF | sudo tee $ROOTFS/etc/X11/xorg.conf.d/99-imggpu.conf > /dev/null
Section "Device"
        Identifier "imggpu"
        Driver "pvrdri"
        Option "kmsdev" "$IMGGPU_DISP_DEV"
EndSection
EOF

  echo "pvrsrvkm" | sudo tee $ROOTFS/etc/modules-load.d/imggpu.conf
fi
