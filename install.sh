yum install -y vim docker cockpit cockpit-machines qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
systemctl enable --now docker
systemctl enable --now libvirtd


curl -o /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

firewall-cmd --permanent \
    --add-port 8600/tcp --add-port 8600/udp \
    --add-port 8500/tcp --add-port 8501/tcp --add-port 8502/tcp \
    --add-port 8301/tcp --add-port 8301/udp --add-port 8302/tcp --add-port 8302/udp \
    --add-port 8300/tcp # Consul Server
firewall-cmd --permanent --add-port 4646/tcp --add-port 4647/tcp --add-port 4648/tcp --add-port 4648/udp # Nomad
firewall-cmd --permanent --add-port 80/tcp --add-port 9998/tcp --add-port 9999/tcp  # Fabio
firewall-cmd --reload



yum install -y consul
cat > /etc/consul.d/z_myconfig.hcl <<EOF
ui_config {
  enabled = true
}
server = true
bootstrap_expect = 3
retry_join = [ "10.0.0.111", "10.0.0.112", "10.0.0.113" ]
bind_addr = "10.0.0.112"
EOF

systemctl enable --now consul


yum install -y nomad
cat > /etc/nomad.d/nomad.hcl <<EOF
data_dir = "/opt/nomad"
server {
  # license_path is required as of Nomad v1.1.1+
  #license_path = "/opt/nomad/license.hclic"
  enabled          = true
}

client {
  enabled = true
}
EOF
systemctl enable --now nomad













# =================== Ubuntu ===================

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
ufw disabled

apt-get update
apt-get install libvirt-daemon-system virtinst qemu-kvm docker.io libvirt-clients
apt-get install consul

yum install -y consul
cat > /etc/consul.d/z_myconfig.hcl <<EOF
ui_config {
  enabled = true
}
server = false
retry_join = [ "10.0.0.111", "10.0.0.112", "10.0.0.113" ]
# bind_addr = "10.0.0.114"
EOF


apt-get install nomad
cat > /etc/nomad.d/nomad.hcl <<EOF
data_dir = "/opt/nomad"
server {
  # license_path is required as of Nomad v1.1.1+
  #license_path = "/opt/nomad/license.hclic"
  enabled          = false
}

client {
  enabled = true
}
EOF
systemctl enable --now nomad




# mkdir -p /opt/nomad/plugins
# curl -o /opt/nomad/plugins/ https://releases.hashicorp.com/nomad-driver-podman/0.4.1/nomad-driver-podman_0.4.1_linux_amd64.zip
