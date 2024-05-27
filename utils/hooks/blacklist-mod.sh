#!/bin/bash

echo "blacklist evbug" | sudo tee $ROOTFS/etc/modprobe.d/sg2042-evbug.conf
