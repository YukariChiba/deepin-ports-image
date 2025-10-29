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
readarray -t INCREPOS_DEV < $(. ./profiles/repos/device.sh)
INCREPOS=("${INCREPOS[@]}" "${INCREPOS_DEV[@]}")

if [ ! -z $INTERNAL_REPO ]; then
  if [ -f "./profiles/repos-internal/$REPOPROFILE.txt" ]; then
    readarray -t INCREPOS_INTERNAL < ./profiles/repos-internal/$REPOPROFILE.txt
  else
    readarray -t INCREPOS_INTERNAL < ./profiles/repos/$REPOPROFILE.txt
  fi
  readarray -t INCREPOS_INTERNAL_DEV < $(. ./profiles/repos-internal/device.sh)
  INCREPOS_INTERNAL=("${INCREPOS_INTERNAL[@]}" "${INCREPOS_INTERNAL_DEV[@]}")
  INCREPOS_INSTALL=("${INCREPOS_INTERNAL[@]}")
else
  INCREPOS_INSTALL=("${INCREPOS[@]}")
fi

INCPKGS+="`cat ./profiles/packages/$PKGPROFILE.txt | grep -v "^-" | xargs | sed -e 's/ /,/g'`"

if [ ! -z $EXTRAPKGS ]; then
  INCPKGS+=",$EXTRAPKGS"
fi

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

sudo systemd-nspawn -D $ROOTFS bash -c "export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install ${INCPKGS//,/ } && apt clean"
