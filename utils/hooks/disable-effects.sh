#!/bin/bash

if ([ "$TARGET_ARCH" == "riscv64" ] && [ "$TARGET_DEVICE" != "sg2042" ]) || [ "$TARGET_DEVICE" == "phytiumpi" ]; then
  if [ ! -z $IMGGPU ]; then
    echo_bold "--- Set graphical effects for IMG GPU"
    echo "QT_QUICK_BACKEND=software" | sudo tee -a $ROOTFS/etc/environment > /dev/null || true
    echo "KWIN_COMPOSE=O2ES" | sudo tee -a $ROOTFS/etc/environment > /dev/null || true
    echo "QT_XCB_GL_INTEGRATION=xcb_egl" | sudo tee -a $ROOTFS/etc/environment > /dev/null || true
  else
    if [ -z $AMDGPU ]; then
      echo_bold "--- Disabled graphical effects"
      if [ -f "$ROOTFS/etc/xdg/deepin-kwinrc" ]; then
        sudo sed -i '/\[Compositing\]/aEnabled=false' $ROOTFS/etc/xdg/deepin-kwinrc || true
        sudo sed -i '/\[Compositing\]/aOpenGLIsUnsafe=false' $ROOTFS/etc/xdg/deepin-kwinrc || true
        sudo sed -i '/\[Plugins\]/amagiclampEnabled=false' $ROOTFS/etc/xdg/deepin-kwinrc || true
      fi
      echo "QT_QUICK_BACKEND=software" | sudo tee -a $ROOTFS/etc/environment || true
    fi
  fi
  if [[ ${INCPKGS[@]} =~ deepin-installer ]]; then
    sudo sed -i '/setup_kwin_blur$/d; /start_kwin ||/d' $ROOTFS/usr/share/deepin-installer/tools/functions/xrandr.sh
  fi
fi
