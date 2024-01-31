#!/bin/bash

if [[ ${INCPKGS[@]} =~ deepin-installer ]]; then
  sudo install -D ./utils/hooks/deepin-installer/deepin-installer.conf $ROOTFS/etc/deepin-installer/deepin-installer.conf
  echo -n 'apt_source_deb="' | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  for INCREPO in "${INCREPOS[@]}"
  do
  echo -n "$INCREPO\\n\\n" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  done
  echo -n '"' | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  sudo ln -s ../deepin-installer-first-boot.service $ROOTFS/usr/lib/systemd/system/multi-user.target.wants/deepin-installer-first-boot.service
  if [ "$TARGET_ARCH" == "riscv64" ]; then
    sudo sed -i 's/setup_kwin_blur$//' $ROOTFS/usr/share/deepin-installer/tools/functions/xrandr.sh
  fi
fi
