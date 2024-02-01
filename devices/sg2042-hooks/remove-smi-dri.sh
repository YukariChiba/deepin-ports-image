#!/bin/bash

echo "blacklist smifb" | sudo tee $ROOTFS/etc/modprobe.d/sg2042-extgpu.conf
