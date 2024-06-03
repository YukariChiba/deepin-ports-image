#!/bin/bash

# most riscv board have broken hibernate/suspend

cat <<EOF | sudo tee $ROOTFS/etc/systemd/logind.conf.d/disable-hibernate.conf
HandleSuspendKey=ignore
HandleHibernateKey=ignore
IdleAction=ignore
EOF
