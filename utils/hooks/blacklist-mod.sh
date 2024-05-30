#!/bin/bash

echo "blacklist evbug" | sudo tee $ROOTFS/etc/modprobe.d/disable-evbug.conf > /dev/null
