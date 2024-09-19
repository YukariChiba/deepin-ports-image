#!/bin/bash

for configsh in ./utils/hooks/*.sh; do
  echo_bold "=== start hook [`basename $configsh`]"
  . $configsh
done

if [ -d "./devices/${TARGET_DEVICE}-hooks" ]; then
  for configsh in ./devices/${TARGET_DEVICE}-hooks/*.sh; do
    echo_bold "=== start device hook [`basename $configsh`]"
    . $configsh
  done
fi

