#!/bin/bash

cat <<EOF | sudo tee $ROOTFS/etc/initramfs-tools/hooks/copy-spacemit-firmware
#!/bin/sh

set -e

PREREQ=""

prereqs()
{
        echo "\${PREREQ}"
}

case "\${1}" in
        prereqs)
                prereqs
                exit 0
                ;;
esac

. /usr/share/initramfs-tools/hook-functions

mkdir -p \${DESTDIR}/lib/firmware
cp -a /lib/firmware/esos.elf \${DESTDIR}/lib/firmware
EOF

sudo chmod +x $ROOTFS/etc/initramfs-tools/hooks/copy-spacemit-firmware
