#!/bin/bash

for configsh in ./utils/hooks/*.sh; do
  . $configsh
done

if [ -d "./devices/${TARGET_DEVICE}-hooks" ]; then
  for configsh in ./devices/${TARGET_DEVICE}-hooks/*.sh; do
    . $configsh
  done
fi

