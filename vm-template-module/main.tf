resource "google_compute_region_instance_template" "default" {
  name        = var.instance_template_name
  description = "This template is used to create vm instances."
  region      = var.region
  tags        = var.tags

  instance_description = "instance created by load balancer"
  machine_type         = var.machine_type

  disk {
    source_image = var.source_image
    auto_delete  = var.instance_template_disk_auto_delete
    boot         = var.instance_template_disk_boot
    disk_type    = var.boot_disk_type
    disk_size_gb = var.boot_disk_size
    source_image_encryption_key {
      kms_key_self_link = var.crypto_vm_key_id
    }
    disk_encryption_key {
      kms_key_self_link = var.crypto_vm_key_id
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {
      network_tier = var.instance_template_network_interface_network_tier
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

      sudo chcon -t systemd_unit_file_t /home/csye6225/app/.env

      sudo systemctl daemon-reload

      systemctl restart google-cloud-ops-agent

      systemctl start runApp

      EOT

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_region_autoscaler" "default" {
  name   = var.autoscaler_name
  target = google_compute_region_instance_group_manager.default.id
  region = var.region
  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = var.autoscaler_autoscaling_policy_cooldown_period

    cpu_utilization {
      target = var.autoscaler_cpu_utilization_target
    }
  }
}

resource "google_compute_region_instance_group_manager" "default" {
  name   = var.group_manager_name
  region = var.region
  named_port {
    name = var.group_manager_named_port_name
    port = var.group_manager_named_port_port
  }
  version {
    instance_template = google_compute_region_instance_template.default.id
    name              = var.group_manager_version_name
  }
  base_instance_name = var.group_manager_base_instance_name

  depends_on = [google_compute_health_check.default]
  auto_healing_policies {
    health_check      = google_compute_health_check.default.id
    initial_delay_sec = var.group_manager_auto_healing_initial_delay_sec
  }
}

resource "google_compute_global_address" "default" {
  name         = var.lb_compute_address_name
  address_type = var.lb_compute_address_address_type
  # network_tier = var.lb_compute_address_network_tier
  # region       = var.region
}

resource "google_compute_health_check" "default" {
  name                = var.health_check_name
  check_interval_sec  = var.health_check_check_interval_sec
  healthy_threshold   = var.health_check_healthy_threshold
  timeout_sec         = var.health_check_timeout_sec
  unhealthy_threshold = var.health_check_unhealthy_threshold
  http_health_check {
    request_path = var.health_check_http_health_chec_request_path
    port         = var.health_check_http_health_check_port
    host         = var.health_check_http_health_check_host
  }
  log_config {
    enable = var.health_check_log_config_enable
  }
}

resource "google_compute_backend_service" "default" {
  name = var.backend_service_name
  # region                = var.region
  load_balancing_scheme = var.backend_service_load_balancing_scheme
  # locality_lb_policy    = var.backend_service_locality_lb_policy
  health_checks    = [google_compute_health_check.default.id]
  protocol         = var.backend_service_protocol
  session_affinity = var.backend_service_session_affinity
  timeout_sec      = var.backend_service_timeout_sec
  backend {
    group           = google_compute_region_instance_group_manager.default.instance_group
    balancing_mode  = var.backend_service_backend_balancing_mode
    capacity_scaler = var.backend_service_backend_capacity_scaler
  }
  log_config {
    enable      = var.backend_service_log_config_enable
    sample_rate = var.backend_service_log_config_sample_rate
  }
}

resource "google_compute_url_map" "default" {
  name = var.url_map_name
  # region          = var.region
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_managed_ssl_certificate" "lb_default" {
  name = var.ssl-certificate-name
  managed {
    domains = [var.DOMAIN_NAME]
  }
}

resource "google_compute_target_https_proxy" "default" {
  name = var.target_http_proxy_name
  # region  = var.region
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.lb_default.name]
}

resource "google_compute_global_forwarding_rule" "default" {
  name = var.lb_forwarding_rule_name
  # project    = var.project_id
  # region     = var.region

  ip_protocol           = var.lb_forwarding_rule_ip_protocol
  load_balancing_scheme = var.lb_forwarding_rule_load_balancing_scheme
  port_range            = var.lb_forwarding_rule_port_range
  target                = google_compute_target_https_proxy.default.id
  # network               = var.vpc_id
  ip_address = google_compute_global_address.default.address
  # network_tier          = var.lb_forwarding_rule_network_tier
}
