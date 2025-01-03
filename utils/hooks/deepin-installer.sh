#!/bin/bash

if [[ ${INCPKGS[@]} =~ deepin-installer ]]; then
  echo_bold "--- deepin-installer detected, update config"
  sudo install -D ./utils/hooks/deepin-installer/deepin-installer.conf $ROOTFS/etc/deepin-installer/deepin-installer.conf

  echo -n "DI_APT_SOURCE_DEB=\"" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  for INCREPO in "${INCREPOS[@]}"
  do
    echo -n "$INCREPO\\n\\n" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf > /dev/null
  done
  echo -n '"' | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  echo "\n" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf

  sudo ln -s ../deepin-installer-first-boot.service $ROOTFS/usr/lib/systemd/system/multi-user.target.wants/deepin-installer-first-boot.service
  sudo rm $ROOTFS/usr/lib/systemd/system/deepin-installer.service
fi
