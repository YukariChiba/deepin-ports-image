#!/bin/bash

mkdir -p tmp results

FSFMT=ext4
BOOTFMT=ext4
DISKSIZE=18000
BOOTSIZE=0
EFISIZE=0
COMPONENTS=main,community,commercial
PKGPROFILE=desktop
REPOPROFILE=main
ROOTLABEL=root
BOOTLABEL=boot
EFILABEL=efi
TAILSPACE=256M

REPOPROFILE=25
COMPONENTS=crimson

function echo_bold()
{
  echo "$(tput bold)$@ $(tput sgr0)"
}

export -f echo_bold

function mkfs_helper()
{
  case "$1" in
    "ext4")
      _TMP_CMD="mkfs.ext4 -b 4096"
      ;;
    "fat32")
      _TMP_CMD="mkfs.fat -F 32 -S 4096"
      ;;
    "exfat")
      _TMP_CMD="mkfs.exfat -s 4096"
      ;;
    *)
      _TMP_CMD="mkfs.$1"
      ;;
  esac
  sudo ${_TMP_CMD} $2
  unset _TMP_CMD
}
