#!/bin/bash

if [ ! -f "./profiles/repos/$REPOPROFILE.txt" ]; then
	echo "error: repo list of profile '$REPOPROFILE' not found"
	exit 1
fi

if [ ! -f "./profiles/packages/$PKGPROFILE.txt" ]; then
	echo "error: packages list of profile '$PKGPROFILE' not found"
	exit 1
fi

readarray -t INCREPOS < ./profiles/repos/$REPOPROFILE.txt

if [ ! -z $INTERNAL_REPO ]; then
  if [ -f "./profiles/repos-internal/$REPOPROFILE.txt" ]; then
    readarray -t INCREPOS_INTERNAL < ./profiles/repos-internal/$REPOPROFILE.txt
  else
    readarray -t INCREPOS_INTERNAL < ./profiles/repos/$REPOPROFILE.txt
  fi
  INCREPOS_INSTALL=("${INCREPOS_INTERNAL[@]}")
else
  INCREPOS_INSTALL=("${INCREPOS[@]}")
fi

INCPKGS+="`cat ./profiles/packages/$PKGPROFILE.txt | grep -v "^-" | grep -v "^#" | xargs | sed -e 's/ /,/g'`"

BASE_CACHE="$(pwd)/cache/base-$REPOPROFILE-$PKGPROFILE-$TARGET_ARCH.tar.gz"

if [ -f $BASE_CACHE ]; then

sudo tar xzf $BASE_CACHE -C $ROOTFS

else

sudo mmdebstrap \
	--hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
	--include=ca-certificates,deepin-keyring,perl-openssl-defaults,deepin-ports-keyring \
	--skip=check/empty \
	--aptopt='APT::Get::AllowUnauthenticated "true"' \
	--aptopt='Acquire::AllowInsecureRepositories "true"' \
	--aptopt='Acquire::AllowDowngradeToInsecureRepositories "true"' \
	--architectures=$TARGET_ARCH $COMPONENTS \
	$ROOTFS \
	"${INCREPOS_INSTALL[@]}"

sudo systemd-nspawn -D $ROOTFS bash -c "export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install ${INCPKGS//,/ }"

if [ -f $ROOTFS/usr/bin/ll-cli ]; then

  if [ ! -z $INTERNAL_REPO ]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "ll-cli --no-dbus repo update stable https://mirror-repo-linglong.uniontech.com"
  fi

  cat $ROOTFS/etc/packages.linglong.* | grep -v '#' | sudo tee $ROOTFS/etc/packages.linglong
  sudo systemd-nspawn -D $ROOTFS bash -c "xargs -n1 --arg-file=/etc/packages.linglong ll-cli --no-dbus install"

  if [ ! -z $INTERNAL_REPO ]; then
    sudo systemd-nspawn -D $ROOTFS bash -c "ll-cli --no-dbus repo update stable https://mirror-repo-linglong.deepin.com"
  fi
fi

sudo systemd-nspawn -D $ROOTFS bash -c "apt clean"

pushd $ROOTFS
  sudo tar czf $BASE_CACHE .
popd

fi
