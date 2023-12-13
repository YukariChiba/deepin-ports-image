#!/bin/sh

set -eu

if [ "${MMDEBSTRAP_VERBOSITY:-1}" -ge 3 ]; then
        set -x
fi

rootdir="$1"

systemd-nspawn -D $rootdir bash -c "(useradd -m -g users deepin || true) && (usermod -a -G sudo deepin || true)"

systemd-nspawn -D $rootdir bash -c "chsh -s /bin/bash deepin || true"

systemd-nspawn -D $rootdir bash -c "(echo root:deepin | chpasswd) || true"
systemd-nspawn -D $rootdir bash -c "(echo deepin:deepin | chpasswd) || true"

