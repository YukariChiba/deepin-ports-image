if [ "$TARGET_DEVICE" == "p1" ] || [ "$TARGET_DEVICE" == "rvbook-zhihe" ]; then
  # password policy
  sudo sed -i 's/minlen=1/minlen=12 obscure/' $ROOTFS/etc/pam.d/common-password

  # update-deviceinfo script
  sudo cp ./devices/$TARGET_DEVICE-hooks/zhihe/deviceinfo.sh $ROOTFS/usr/bin/update-deviceinfo
  sudo chmod +x $ROOTFS/usr/bin/update-deviceinfo
  sudo cp ./devices/$TARGET_DEVICE-hooks/zhihe/update-deviceinfo.service $ROOTFS/usr/lib/systemd/system/update-deviceinfo.service
  sudo ln -s $ROOTFS/lib/systemd/system/update-deviceinfo.service $ROOTFS/etc/systemd/system/multi-user.target.wants/update-deviceinfo.service

  # use chromium, remove firefox
  sudo systemd-nspawn -D $ROOTFS bash -c "apt purge -y firefox"
fi
