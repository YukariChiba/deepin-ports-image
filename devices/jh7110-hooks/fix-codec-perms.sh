#!/bin/bash

cat <<EOF | sudo tee $ROOTFS/etc/udev/rules.d/jh7110-codecs.rules
SUBSYSTEM=="vdec", MODE="0666"
SUBSYSTEM=="venc", MODE="0666"
EOF
