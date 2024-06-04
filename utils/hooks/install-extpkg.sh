#!/bin/bash

if [ -d "./injectbin/extradeb/$TARGET_DEVICE" ]; then
  echo_bold "--- Found extra deb"
  sudo mkdir -p $ROOTFS/extrainstall
  sudo cp -r ./injectbin/extradeb/$TARGET_DEVICE $ROOTFS/extrainstall/
  sudo systemd-nspawn -D $ROOTFS bash -c "(dpkg -i \`find /extrainstall -name '*.deb' | xargs\` || true) && rm -r /extrainstall"
fi
