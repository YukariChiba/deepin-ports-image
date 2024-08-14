#!/bin/bash

if [[ ! ${INCPKGS[@]} =~ org.deepin.browser ]]; then
  sudo rm $ROOTFS/etc/skel/Desktop/org.deepin.browser.desktop || true
fi

if [ "$TARGET_ARCH" == "riscv64" ]; then
  sudo rm $ROOTFS/etc/skel/Desktop/deepin-manual.desktop || true
fi
