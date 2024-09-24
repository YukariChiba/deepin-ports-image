#!/bin/bash

uploadarch=${1:-riscv64}
uploaddir=/storage/repos/deepin-ports/cdimage/$(date "+%Y%m%d")/$uploadarch

ssh deepin@repo -p 2222 mkdir -p $uploaddir

scp -P 2222 ./results-img/*.tar.xz deepin@repo:$uploaddir/
