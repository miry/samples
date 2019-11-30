resource "libvirt_pool" "fedora" {
  name = "fedora"
  type = "dir"
  path = "/tmp/terraform-provider-libvirt-pool-fedora"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "fedora" {
  name   = "fedora"
  pool   = libvirt_pool.fedora.name
  source = "http://ftp.tu-chemnitz.de/pub/linux/fedora/linux/releases/31/Cloud/x86_64/images/Fedora-Cloud-Base-31-1.9.x86_64.qcow2"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "cloudinit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.linux.name
}

resource "libvirt_domain" "fedora" {
  name   = "fedora"
  memory = "2048"
  vcpu   = 2
  wait_for_lease = true

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name = "kube"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.fedora.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "address" {
  value = concat(libvirt_domain.domain-ubuntu.network_interface.*.addresses)
}
