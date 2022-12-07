yum install -y vim docker cockpit cockpit-machines qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
systemctl enable --now docker
systemctl enable --now libvirtd


curl -o /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

#firewall-cmd --permanent \
#    --add-port 8600/tcp --add-port 8600/udp \
#    --add-port 8500/tcp --add-port 8501/tcp --add-port 8502/tcp \
#    --add-port 8301/tcp --add-port 8301/udp --add-port 8302/tcp --add-port 8302/udp \
#    --add-port 8300/tcp # Consul Server
#firewall-cmd --permanent --add-port 4646/tcp --add-port 4647/tcp --add-port 4648/tcp --add-port 4648/udp # Nomad
#firewall-cmd --permanent --add-port 80/tcp --add-port 9998/tcp --add-port 9999/tcp  # Fabio
#firewall-cmd --reload


export MY_IP=$(ip addr | grep -o "10.0.0.[0-9]" | tail -1)
yum install -y consul
cat > /etc/consul.d/z_myconfig.hcl <<EOF
ui_config {
  enabled = true
}
server = true
bootstrap_expect = 3
retry_join = [ "10.0.0.2", "10.0.0.3", "10.0.0.4" ]
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "$MY_IP"
EOF

systemctl enable --now consul


yum install -y nomad
cat > /etc/nomad.d/nomad.hcl <<EOF
data_dir = "/opt/nomad"
server {
  # license_path is required as of Nomad v1.1.1+
  #license_path = "/opt/nomad/license.hclic"
  enabled          = true
  bootstrap_expect  = 3
}
consul {
  address = "$MY_IP:8500"
}
bind_addr = "0.0.0.0" # the default

advertise {
  # Defaults to the first private IP address.
  http = "$MY_IP"
  rpc  = "$MY_IP"
  serf = "$MY_IP" # non-default ports may be specified
}
client {
  enabled = true
}
EOF
systemctl enable --now nomad


systemctl restart consul
systemctl stop nomad
rm -rf /opt/nomad
systemctl start nomad






# =================== Ubuntu ===================

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
ufw disable

apt-get update
apt-get install -y libvirt-daemon-system virtinst qemu-kvm docker.io libvirt-clients
apt-get install consul

apt-get install -y consul
cat > /etc/consul.d/z_myconfig.hcl <<EOF
ui_config {
  enabled = true
}
server = false
retry_join = [ "10.0.0.2", "10.0.0.3", "10.0.0.4" ]
bind_addr = "10.0.0.5"
EOF


apt-get install nomad
cat > /etc/nomad.d/nomad.hcl <<EOF
data_dir = "/opt/nomad"
server {
  # license_path is required as of Nomad v1.1.1+
  #license_path = "/opt/nomad/license.hclic"
  enabled          = false
}
bind_addr = "10.0.0.5" # the default

client {
  enabled = true
}
EOF
systemctl enable --now nomad

systemctl restart consul
systemctl stop nomad
rm -rf /opt/nomad
systemctl start nomad


# mkdir -p /opt/nomad/plugins
# curl -o /opt/nomad/plugins/ https://releases.hashicorp.com/nomad-driver-podman/0.4.1/nomad-driver-podman_0.4.1_linux_amd64.zip
