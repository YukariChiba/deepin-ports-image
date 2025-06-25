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
if [ -f "./profiles/repos/devices/$TARGET_DEVICE.txt" ]; then
  readarray -t INCREPOS_DEV < ./profiles/repos/devices/$TARGET_DEVICE.txt
  INCREPOS=("${INCREPOS[@]}" "${INCREPOS_DEV[@]}")
fi

if [ ! -z $INTERNAL_REPO ]; then
  if [ -f "./profiles/repos-internal/$REPOPROFILE.txt" ]; then
    readarray -t INCREPOS_INTERNAL < ./profiles/repos-internal/$REPOPROFILE.txt
  else
    readarray -t INCREPOS_INTERNAL < ./profiles/repos/$REPOPROFILE.txt
  fi
  if [ -f "./profiles/repos-internal/devices/$TARGET_DEVICE.txt" ]; then
    readarray -t INCREPOS_INTERNAL_DEV < ./profiles/repos-internal/devices/$TARGET_DEVICE.txt
    INCREPOS_INTERNAL=("${INCREPOS_INTERNAL[@]}" "${INCREPOS_INTERNAL_DEV[@]}")
  else
    INCREPOS_INTERNAL=("${INCREPOS_INTERNAL[@]}" "${INCREPOS_DEV[@]}")
  fi
  INCREPOS_INSTALL=("${INCREPOS_INTERNAL[@]}")
else
  INCREPOS_INSTALL=("${INCREPOS[@]}")
fi

INCPKGS+="`cat ./profiles/packages/$PKGPROFILE.txt | grep -v "^-" | xargs | sed -e 's/ /,/g'`"

if [ ! -z $EXTRAPKGS ]; then
  INCPKGS+=",$EXTRAPKGS"
fi

if [ "$PKGPROFILE" == "desktop-installer" ] && [ "$REPOPROFILE" == "25" ]; then
  INCPKGS+=",ddm,treeland,wlr-randr"
fi

sudo mmdebstrap \
	--hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
	--include=ca-certificates,deepin-keyring,perl-openssl-defaults \
	--skip=check/empty \
	--aptopt='APT::Get::AllowUnauthenticated "true"' \
	--aptopt='Acquire::AllowInsecureRepositories "true"' \
	--aptopt='Acquire::AllowDowngradeToInsecureRepositories "true"' \
	--architectures=$TARGET_ARCH $COMPONENTS \
	$ROOTFS \
	"${INCREPOS_INSTALL[@]}"

sudo systemd-nspawn -D $ROOTFS bash -c "export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install ${INCPKGS//,/ }"
