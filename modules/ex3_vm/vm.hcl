job "vm" {
  datacenters = ["dc1"]
  type = "service"

  group "vmgroup" {
    count =1
    network {
      // mode = "bridge"
    }
    task "centos" {
      driver = "qemu"

      // Does not use libvirt > No interop with anything
      config {
        image_path        = "local/CentOS-Stream-GenericCloud-9-20220308.0.x86_64.qcow2"
        accelerator       = "kvm"
        graceful_shutdown = true
        /// The Args parameter is unreasonable long
        args              = [
          "-nodefaults",
          "-no-user-config",
          "-net",
          "bridge,br=virbr0",
          // "-net",
          // "nic,model=virtio,macaddr=00:c0:eb:e3:19:3${NOMAD_ALLOC_INDEX}",
          // "-cdrom",
          // "local/cloudinit.iso",
          "-vga"
        ]
      }
      artifact {
        source = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20220308.0.x86_64.qcow2"
      }
      // artifact {
      //   source = "cloudinit.iso"
      // }

      resources {
        cpu    = 1000 # MHz
        memory = 2048 # MB
      }
    }
  }
}