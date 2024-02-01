#!/bin/bash

FSFMT=ext4
BOOTFMT=fat32
COMPONENTS=main,community,commercial
PKGPROFILE=desktop
REPOPROFILE=main
ROOTLABEL=root
BOOTLABEL=boot

function echo_bold()
{
  echo "$(tput bold)$@ $(tput sgr0)"
}
