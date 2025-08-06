#!/bin/bash

sudo systemd-nspawn -D $ROOTFS bash -c "(echo root:deepin | chpasswd) || true"

if [[ ! ${INCPKGS[@]} =~ deepin-installer ]]; then
  sudo systemd-nspawn -D $ROOTFS bash -c "(useradd -m -g users deepin || true) && (usermod -a -G sudo deepin || true)"
  sudo systemd-nspawn -D $ROOTFS bash -c "chsh -s /bin/bash deepin || true"
  sudo systemd-nspawn -D $ROOTFS bash -c "(echo deepin:deepin | chpasswd) || true"

  cat <<EOF | sudo tee $ROOTFS/etc/locale.gen
en_US UTF-8
zh_CN GB2312
zh_CN.GB18030 GB18030
zh_CN.GBK GBK
zh_CN.UTF-8 UTF-8
zh_HK.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8
EOF
  cat << EOF | sudo tee $ROOTFS/etc/locale.conf
LANG=zh_CN.UTF-8
LANGUAGE=zh_CN
EOF
  sudo systemd-nspawn -D $ROOTFS bash -c "locale-gen"
fi
