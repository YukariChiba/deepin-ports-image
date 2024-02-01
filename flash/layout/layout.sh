#!/bin/bash

sgdisk --clear --set-alignment=2 \
  --new=1:4096:8191    --change-name=1:"spl"   --typecode=1:2E54B353-1271-4842-806F-E436D6AF6985 \
  --new=2:8192:16383   --change-name=2:"uboot" --typecode=2:5B193300-FC78-40CD-8002-E86C45580B47 \
  --new=3:16384:1064959 --change-name=3:"boot" --typecode=3:EBD0A0A2-B9E5-4433-87C0-68B6B72699C7 \
  --new=4:1064960:0     --change-name=4:"root"  --typecode=4:0FC63DAF-8483-4772-8E79-3D69D8477DE4 \
  /dev/loop0
