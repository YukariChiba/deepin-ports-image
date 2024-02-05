#!/bin/bash

if [ -f $ROOTFS/usr/bin/deepin-movie ]; then
  sudo sed -i 's/gpu,xv,x11/xv,x11    /' $ROOTFS/usr/bin/deepin-movie
fi
