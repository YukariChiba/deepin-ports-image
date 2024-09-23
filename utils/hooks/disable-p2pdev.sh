cat <<EOF | sudo tee -a /etc/NetworkManager/NetworkManager.conf

[keyfile]
unmanaged-devices=interface-name:p2p0
EOF
