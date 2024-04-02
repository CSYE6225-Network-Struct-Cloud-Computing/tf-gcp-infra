resource "random_id" "password_sql" {
  byte_length = 4
}

resource "google_sql_database_instance" "default" {
  name             = "sqldatabaseinstancename"
  region           = "us-east1"
  database_version = var.database_version_SQL
  settings {
    tier              = var.sql_tier
    availability_type = var.sql_availability_type
    disk_type         = var.sql_disk_type
    disk_size         = var.sql_disk_size
    backup_configuration {
      enabled            = var.sql_backup_configuration_enabled
      binary_log_enabled = var.sql_backup_configuration_binary_log_enabled
    }
    ip_configuration {
      psc_config {
        psc_enabled               = var.sql_psc_enabled
        allowed_consumer_projects = var.sql_allowed_consumer_projects
      }
      ipv4_enabled = var.sql_ipv4_enabled
    }
  }
  deletion_protection = var.sql_deletion_protection
}

resource "google_compute_address" "default" {
  name         = "psc-compute-address"
  address_type = var.compute_address_address_type
  subnetwork   = var.compute_address_subnetwork
  address      = var.compute_address_address
}

data "google_sql_database_instance" "default" {
  name       = google_sql_database_instance.default.name
  depends_on = [google_sql_database.database]
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "psc-forwarding-rule"
  network               = var.compute_forwarding_rule_network
  ip_address            = google_compute_address.default.self_link
  load_balancing_scheme = var.compute_forwarding_rule_load_balancing_schema
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
