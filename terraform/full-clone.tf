locals {
  vm_configs = yamldecode(file("${path.module}/vm_configs.yaml"))
}

resource "proxmox_vm_qemu" "vm_provision" {
  for_each = local.vm_configs

  target_node = each.value.target_node
  vmid = each.value.vmid
  name = each.key
  desc = each.value.description
  onboot = true
  clone = each.value.clone
  agent = 1
  cores = each.value.resources.cpu
  memory = each.value.resources.memory
  ipconfig0 = "ip=dhcp"
  os_type = "ubuntu"
  scsihw = "virtio-scsi-pci"
  tags = each.value.tags

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disk {
    type = "virtio"
    storage = "local-lvm"
    backup  = true
    cache   = "none"
    file    = "vm-${each.value.vmid}-disk-0"
    format  = "raw"
    size = each.value.resources.disk
    volume  = "local-lvm:vm-${each.value.vmid}-disk-0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
