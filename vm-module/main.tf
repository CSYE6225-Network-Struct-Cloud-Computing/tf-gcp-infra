resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type

  tags = var.tags
  zone = var.zone
  boot_disk {
    device_name = var.vm_name

    initialize_params {
      image = var.boot_disk_image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }

  network_interface {
    access_config {
      network_tier = var.network_tier
    }
    subnetwork = var.subnetwork
    stack_type = var.stack_type
  }
}
