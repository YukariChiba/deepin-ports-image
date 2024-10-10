if ls $ROOTFS/usr/lib/modules/*/extra 1> /dev/null 2>&1; then

  sudo mkdir -p $ROOTFS/etc/depmod.d

  cat <<EOF | sudo tee $ROOTFS/etc/depmod.d/extra.conf
search extra
EOF

fi
