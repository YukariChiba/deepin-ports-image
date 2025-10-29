#!/bin/bash

if [ ! -z $DEVICEREPO ]; then

cat <<EOF
deb http://10.20.64.70/deepin-ports/repo/ ports $DEVICEREPO
EOF

fi
