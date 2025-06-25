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
