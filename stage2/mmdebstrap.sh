#!/usr/bin/bash

useradd -m -g users deepin
usermod -a -G sudo deepin

chsh -s /bin/bash deepin

echo root:deepin | chpasswd
echo deepin:deepin | chpasswd

