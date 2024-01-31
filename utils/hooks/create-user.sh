#!/bin/bash

#sudo systemd-nspawn -D $ROOTFS bash -c "(echo root:deepin | chpasswd) || true"

if [[ ! ${INCPKGS[@]} =~ deepin-installer ]]; then
  sudo systemd-nspawn -D $ROOTFS bash -c "(useradd -m -g users deepin || true) && (usermod -a -G sudo deepin || true)"
  sudo systemd-nspawn -D $ROOTFS bash -c "chsh -s /bin/bash deepin || true"
  sudo systemd-nspawn -D $ROOTFS bash -c "(echo deepin:deepin | chpasswd) || true"
fi
