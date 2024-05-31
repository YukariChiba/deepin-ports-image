##!/bin/bash

if [ -d "./injectbin/bootloader/$TARGET_DEVICE" ]; then
  echo_bold "--- Found bootloader partition files"
  mv ./injectbin/bootloader/$TARGET_DEVICE/* ./results/
fi
