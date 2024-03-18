#!/bin/bash

ISOIMG="./results/$IMGPFX.iso"
ISODIR="./results/$IMGPFX"

mkdir -p $ISODIR/boot $ISODIR/live

if [ "$BOOTSIZE" -ne "0" ]; then
  sudo cp -r $ROOTFS/boot/efi/* $ISODIR/boot/
  sudo umount $ROOTFS/boot/efi
fi

sudo mv $ROOTFS/boot/config-* $ISODIR/live
sudo mv $ROOTFS/boot/System.map-* $ISODIR/live
sudo mv $ROOTFS/boot/initrd.img-* $ISODIR/live
sudo mv $ROOTFS/boot/vmlinuz-* $ISODIR/live

sudo mv $ROOTFS/boot/grub/* $ISODIR/boot/grub/
sudo cp $ROOTFS/usr/share/grub/unicode.pf2 $ISODIR/boot/grub

sudo mksquashfs $ROOTFS $ISODIR/live/filesystem.squashfs

sudo xorriso -as mkisofs \
  -o $ISOIMG \
  -J -v -d -N \
  -x $ISOIMG \
  -partition_offset 16 \
  -no-pad \
  -hide-rr-moved \
  -no-emul-boot \
  -append_partition 2 0xef $BOOTIMG \
  -appended_part_as_gpt \
  -eltorito-platform efi \
  -e --interval:appended_partition_2:all:: \
  -V "DEEPIN_ISO" \
  -A "deepin Live ISO"  \
  -iso-level 3 \
  -partition_cyl_align all \
  $ISODIR

sudo rm -r $ROOTFS
