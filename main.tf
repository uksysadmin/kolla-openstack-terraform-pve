terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}
provider "proxmox" {
  pm_api_url = "https://${var.proxmox_host}:8006/api2/json" # change this to match your own proxmox
  pm_api_token_id = "${var.proxmox_api_token_id}"
  pm_api_token_secret = "${var.proxmox_api_token_secret}"
  pm_tls_insecure = true
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox-vm.log"
}
resource "proxmox_vm_qemu" "controllers" {
  count = 1
  name = "controller-0${count.index + 1}"
  target_node = "${var.pve_node}"
  vmid = "200${count.index + 1}"
  clone = "${var.template_name}"
  full_clone = "false"
  agent = 1
  os_type = "cloud-init"
  cloudinit_cdrom_storage = "ovm-hdd"
  cores = 2
  ci_wait= 40
  sockets = 2
  cpu = "host"
  memory = 8192
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disks {
    scsi {
      scsi0 {
        disk {
          size = "64"
          storage = "local-lvm"
        }
      }
    }
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr17"
  }
  network {
    model = "virtio"
    bridge = "vmbr20"
  }
  lifecycle {
    ignore_changes = [
     network,
    ]
  }

  ipconfig0 = "ip=192.168.70.1${count.index + 1}/22,gw=192.168.68.1"
  ipconfig1 = "ip=10.17.0.1${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "compute" {
  count = 2
  name = "compute-0${count.index + 1}"
  target_node = "${var.pve_node}"
  vmid = "210${count.index + 1}"
  clone = "${var.template_name}"
  full_clone = "false"
  agent = 1
  os_type = "cloud-init"
  cloudinit_cdrom_storage = "ovm-hdd"
  cores = 2
  sockets = 2
  cpu = "host"
  memory = 8192
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disks {
    scsi {
      scsi0 {
        disk {
          size = "128"
          storage = "local-lvm"
        }
      }
    }
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  network {
    model = "virtio"
    bridge = "vmbr17"
  }
  network {
    model = "virtio"
    bridge = "vmbr20"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = "ip=192.168.70.2${count.index + 1}/22,gw=192.168.68.1"
  ipconfig1 = "ip=10.17.0.3${count.index + 1}/22"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

