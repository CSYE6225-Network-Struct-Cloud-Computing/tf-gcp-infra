resource "google_compute_region_instance_template" "default" {
  name        = "vm-template"
  description = "This template is used to create vm instances."
  region      = var.region
  tags        = var.tags

  instance_description = "instance created by load balancer"
  machine_type         = var.machine_type

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
    disk_type    = var.boot_disk_type
    disk_size_gb = var.boot_disk_size
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {
      network_tier = "STANDARD"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

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
      echo "TOPIC_ID=${var.TOPIC_ID}" >> /tmp/.env
      echo "PROJECT_ID=${var.PROJECT_ID}" >> /tmp/.env

      mv /tmp/.env /home/csye6225/app/.env
      chown -R csye6225:csye6225 /home/csye6225/app

      systemctl start runApp

      EOT

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_region_autoscaler" "default" {
  name   = "my-autoscaler"
  target = google_compute_region_instance_group_manager.default.id
  region = var.region
  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 30 # min 15

    cpu_utilization {
      target = 0.1
    }
  }
}

resource "google_compute_region_instance_group_manager" "default" {
  name   = "group-manager"
  region = var.region
  named_port {
    name = "http"
    port = 3000
  }
  version {
    instance_template = google_compute_region_instance_template.default.id
    name              = "primary"
  }
  base_instance_name = "vm"
}

resource "google_compute_address" "default" {
  name         = "load-balancer"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
}

resource "google_compute_region_health_check" "default" {
  name                = "basic-check"
  check_interval_sec  = 5
  healthy_threshold   = 2
  timeout_sec         = 2
  unhealthy_threshold = 2
  http_health_check {
    request_path = "/healthz"
    port         = "3000"
    host         = "omsolanki.me"
  }
  log_config {
    enable = true
  }
}

resource "google_compute_region_backend_service" "default" {
  name                  = "backend-service"
  region                = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  locality_lb_policy    = "ROUND_ROBIN"
  health_checks         = [google_compute_region_health_check.default.id]
  protocol              = "HTTP"
  session_affinity      = "NONE"
  timeout_sec           = 30
  backend {
    group           = google_compute_region_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
  log_config {
    enable      = true
    sample_rate = 1
  }
}

resource "google_compute_region_url_map" "default" {
  name            = "regional-map"
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "proxy"
  region  = var.region
  url_map = google_compute_region_url_map.default.id
}

# provider "google" {
#   project = var.project_id
# }

resource "google_compute_forwarding_rule" "default" {
  name       = "load-balancer-forwarding-rule"
  provider   = google-beta
  depends_on = [var.proxy_only_subnet]
  project    = var.project_id
  region     = var.region

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_region_target_http_proxy.default.id
  network               = var.vpc_id
  ip_address            = google_compute_address.default.address
  network_tier          = "STANDARD"
}