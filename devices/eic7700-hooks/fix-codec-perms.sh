#!/bin/bash

cat <<EOF | sudo tee $ROOTFS/etc/udev/rules.d/eswin-codecs.rules
KERNEL=="es_*", MODE="0666"
SUBSYSTEM=="eswin_heap", MODE="0666"
EOF
