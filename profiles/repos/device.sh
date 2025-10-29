#!/bin/bash

if [ ! -z $DEVICEREPO ]; then

cat <<EOF
deb https://ci.deepin.com/repo/deepin/deepin-ports/repo/ ports $DEVICEREPO
EOF

fi
