locals {
  vm_configs = yamldecode(file("${path.module}/vm_configs.yaml"))
}

resource "proxmox_vm_qemu" "vm_provision" {
  for_each = local.vm_configs

  name        = each.key
  desc        = each.value.description
  agent       = 1
  target_node = each.value.target_node
  tags        = each.value.tags

  vmid      = each.value.vmid
  onboot    = true
  clone     = each.value.clone
  cores     = each.value.resources.cpu
  memory    = each.value.resources.memory
  ipconfig0 = each.value.ipconfig0
  os_type   = "ubuntu"
  scsihw    = "virtio-scsi-pci"

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disk {
    type    = "scsi"
    storage = "local-lvm"
    file    = "vm-${each.value.vmid}-disk-0"
    size    = each.value.resources.disk
    volume  = "local-lvm:vm-${each.value.vmid}-disk-0"
    discard = "on"
    ssd     = 1
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
