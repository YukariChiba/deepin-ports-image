#!/bin/bash

echo "# updated by deepin-ports-image" | sudo tee $ROOTFS/etc/apt/sources.list > /dev/null

for INCREPO in "${INCREPOS[@]}"
do
  if [[ $INCREPO =~ "appstore" ]] && [ -f $ROOTFS/etc/apt/sources.list.d/appstore.list ]; then
    echo "SKIP $INCREPO for appstore"
  else
    echo "$INCREPO" | sudo tee -a $ROOTFS/etc/apt/sources.list > /dev/null
  fi
done

if [ -z $INTERNAL_REPO ]; then
  echo "$INCREPOS_DEV" | sudo tee -a $ROOTFS/etc/apt/sources.list > /dev/null
else
  echo "$INCREPOS_INTERNAL_DEV" | sudo tee -a $ROOTFS/etc/apt/sources.list > /dev/null
fi

