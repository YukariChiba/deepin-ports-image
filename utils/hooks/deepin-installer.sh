#!/bin/bash

if [[ ${INCPKGS[@]} =~ deepin-installer ]]; then
  echo_bold "--- deepin-installer detected, update config"
  sudo install -D ./utils/hooks/deepin-installer/deepin-installer.conf $ROOTFS/etc/deepin-installer/deepin-installer.conf
  echo -n 'apt_source_deb="' | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  if [ "$REPOPROFILE" != "stable" ]; then
    for INCREPO in "${INCREPOS[@]}"
    do
      echo -n "$INCREPO\\n\\n" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
    done
  else
    echo -n "deb https://community-packages.deepin.com/deepin/beige/ beige main community commercial\\n\\n" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  fi
  echo -n '"' | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  sudo ln -s ../deepin-installer-first-boot.service $ROOTFS/usr/lib/systemd/system/multi-user.target.wants/deepin-installer-first-boot.service
  if [ "$TARGET_ARCH" == "riscv64" ] && [ "$TARGET_DEVICE" != "sg2042" ]; then
    sudo sed -i 's/setup_kwin_blur$//' $ROOTFS/usr/share/deepin-installer/tools/functions/xrandr.sh
  fi
fi
