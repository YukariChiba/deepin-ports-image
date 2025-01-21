#!/bin/bash

if [[ ${INCPKGS[@]} =~ deepin-installer ]]; then
  echo_bold "--- deepin-installer detected, update config"
  sudo install -D ./utils/hooks/deepin-installer/deepin-installer.conf $ROOTFS/etc/deepin-installer/deepin-installer.conf

  for increpo_var in apt_source_deb DI_APT_SOURCE_DEB; do
    echo -n "${increpo_var}=\"" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
    for INCREPO in "${INCREPOS[@]}"
    do
      echo -n "$INCREPO\\n\\n" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf > /dev/null
    done
    echo -n '"' | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
    echo "\n" | sudo tee -a $ROOTFS/etc/deepin-installer/deepin-installer.conf
  done

  sudo ln -s ../deepin-installer-first-boot.service $ROOTFS/usr/lib/systemd/system/multi-user.target.wants/deepin-installer-first-boot.service
  sudo rm $ROOTFS/usr/lib/systemd/system/deepin-installer.service

  # v23
  if [ -d $ROOTFS/usr/share/deepin-installer ]; then
    sudo sed -i '/setup_kwin_blur$/d; /start_kwin ||/d' $ROOTFS/usr/share/deepin-installer/tools/functions/xrandr.sh
  fi

  # v25
  if [ -d $ROOTFS/var/lib/deepin-installer ]; then
    # enable lightdm
    sudo ln -sf /usr/lib/systemd/system/lightdm.service $ROOTFS/etc/systemd/system/display-manager.service
    # kwin env
    sudo sed -i "/setup_kwin_env().*{/a export KWIN_COMPOSE=O2ES" $ROOTFS/var/lib/deepin-installer/tools/functions/xrandr.sh
  fi
fi
