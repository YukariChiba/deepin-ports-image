#!/bin/bash

if [ "$TARGET_ARCH" == "riscv64" ] && [ "$TARGET_DEVICE" != "sg2042" ]; then
  echo_bold "--- Disabled graphical effects"
  if [ -f "$ROOTFS/etc/xdg/deepin-kwinrc" ]; then
    sudo sed -i '/\[Compositing\]/aEnabled=false' $ROOTFS/etc/xdg/deepin-kwinrc || true
    sudo sed -i '/\[Compositing\]/aOpenGLIsUnsafe=false' $ROOTFS/etc/xdg/deepin-kwinrc || true
    sudo sed -i '/\[Plugins\]/amagiclampEnabled=false' $ROOTFS/etc/xdg/deepin-kwinrc || true
  fi
  echo "QT_QUICK_BACKEND=software" | sudo tee -a $ROOTFS/etc/environment || true
fi
