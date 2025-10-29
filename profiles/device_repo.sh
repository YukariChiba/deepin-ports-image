#!/bin/bash

if [ ! -z $DEVICEREPO ]; then

INCREPOS_DEV="deb https://ci.deepin.com/repo/deepin/deepin-ports/repo/ ports $DEVICEREPO"
INCREPOS_INTERNAL_DEV="deb http://10.20.64.70/deepin-ports/repo/ ports $DEVICEREPO"

fi
