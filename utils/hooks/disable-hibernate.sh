#!/bin/bash

# most riscv board have broken hibernate/suspend

cat <<EOF > $ROOTFS/etc/systemd/logind.conf.d/disable-hibernate.conf
HandleSuspendKey=ignore
HandleHibernateKey=ignore
IdleAction=ignore
EOF
