resource "random_id" "password_sql" {
  byte_length = 4
}

resource "google_sql_database_instance" "default" {
  name             = "sqldatabaseinstancename"
  region           = "us-east1"
  database_version = var.database_version_SQL
  settings {
    tier              = var.google_sql_database_instance_tier
    availability_type = var.google_sql_database_instance_availability_type
    disk_type         = var.google_sql_database_instance_disk_type
    disk_size         = var.google_sql_database_instance_disk_size
    backup_configuration {
      enabled            = var.google_sql_database_instance_backup_configuration_enabled
      binary_log_enabled = var.google_sql_database_instance_backup_configuration_binary_log_enabled
    }
    ip_configuration {
      psc_config {
        psc_enabled               = var.google_sql_database_instance_psc_enabled
        allowed_consumer_projects = var.google_sql_database_instance_allowed_consumer_projects
      }
      ipv4_enabled = var.google_sql_database_instance_ipv4_enabled
    }
  }
  deletion_protection = var.google_sql_database_instance_deletion_protection
}

resource "google_compute_address" "default" {
  name         = "psc-compute-address"
  address_type = var.google_compute_address_address_type
  subnetwork   = var.google_compute_address_subnetwork
  address      = var.google_compute_address_address
}

data "google_sql_database_instance" "default" {
  name       = google_sql_database_instance.default.name
  depends_on = [google_sql_database.database]
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "psc-forwarding-rule"
  network               = var.google_compute_forwarding_rule_network
  ip_address            = google_compute_address.default.self_link
  load_balancing_scheme = var.google_compute_forwarding_rule_load_balancing_schema
  target                = data.google_sql_database_instance.default.psc_service_attachment_link
  depends_on            = [google_sql_database.database]
}

resource "google_sql_database" "database" {
  name     = var.google_sql_database_name
  instance = google_sql_database_instance.default.name
}

resource "google_sql_user" "users" {
  name     = var.google_sql_user_name
  instance = google_sql_database_instance.default.name
  password = random_id.password_sql.hex
}
