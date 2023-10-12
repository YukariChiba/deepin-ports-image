#!/bin/bash

FSFMT=ext4
BOOTFMT=fat32
CACHEPATH=`pwd`/cache
REPO="https://ci.deepin.com/repo/deepin/deepin-community/stable/"
BUILDBOOTIMG=1
INCPKGS=`cat ./packages.txt | xargs | sed -e 's/ /,/g'`
INITEXEC=sbin/init
COMPONENTS=main,community,commercial
