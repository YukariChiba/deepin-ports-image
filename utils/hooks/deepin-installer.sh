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
  echo ""
  #if [ -z $LIVE ]; then
    #sudo ln -s ../deepin-installer.service $ROOTFS/usr/lib/systemd/system/multi-user.target.wants/deepin-installer.service
  #else
    sudo ln -s ../deepin-installer-first-boot.service $ROOTFS/usr/lib/systemd/system/multi-user.target.wants/deepin-installer-first-boot.service
  #fi
fi
