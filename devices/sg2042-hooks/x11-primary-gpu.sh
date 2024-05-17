#!/bin/bash

cat <<EOF | sudo tee /etc/X11/xorg.conf.d/99-primarygpu.conf

Section "OutputClass"
        Identifier "AMDgpu"
        MatchDriver "amdgpu"
        Driver "amdgpu"
	Option "PrimaryGPU" "yes"
EndSection

Section "OutputClass"
        Identifier "Radeon"
        MatchDriver "radeon"
        Driver "radeon"
	Option "PrimaryGPU" "yes"
EndSection

EOF
