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
  # metadata = {
  #   startup_script = var.startup_script
  # }
  metadata_startup_script = <<-EOT
      #!/bin/bash

      touch /tmp/.env

      echo "PORT=${var.PORT}" >> /tmp/.env
      echo "MYSQL_USERNAME=${var.MYSQL_USERNAME}" >> /tmp/.env
      echo "MYSQL_PASSWORD=${var.MYSQL_PASSWORD}" >> /tmp/.env
      echo "MYSQL_DB_NAME=${var.MYSQL_DB_NAME}" >> /tmp/.env
      echo "TEST_MYSQL_DB_NAME=${var.MYSQL_DB_NAME}" >> /tmp/.env
      echo "MYSQL_HOST=${var.MYSQL_HOST}" >> /tmp/.env
      echo "NODE_ENV=production" >> /tmp/.env

      mv /tmp/.env /home/csye6225/app/.env
      chown -R csye6225:csye6225 /home/csye6225/app

      systemctl start runApp

      EOT

}
