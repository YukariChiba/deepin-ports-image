#!/bin/bash

mkdir -p tmp results

FSFMT=ext4
BOOTFMT=ext4
BOOTSIZE=0
COMPONENTS=main,community,commercial
PKGPROFILE=desktop
REPOPROFILE=main
ROOTLABEL=root
BOOTLABEL=boot
TAILSPACE=256M

function echo_bold()
{
  echo "$(tput bold)$@ $(tput sgr0)"
}
