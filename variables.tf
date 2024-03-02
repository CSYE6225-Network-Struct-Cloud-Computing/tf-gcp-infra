variable "project_id" {
}

variable "region" {
  default = "us-east1"
}

variable "vpc_name" {
  default = "myvpc1"
}

variable "webapp_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "webapp_subnet_name" {
  default = "webapp"
}

variable "webapp_subnet_region" {
  default = "us-east1"
}

variable "db_subnet_name" {
  default = "db"
}

variable "db_subnet_region" {
  default = "us-east1"
}

variable "vm_name" {
  default = "vm"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "zone" {
  default = "us-east1-b"
}

variable "boot_disk_image" {
  # Eg boot_disk_image = "projects/"project-id"/global/images/"image-name" "
}

variable "boot_disk_type" {
  default = "pd-standard"
}

variable "tags" {
  type    = list(string)
  default = ["firewall", "webapp"]
}

variable "boot_disk_size" {
  type    = number
  default = 100
}

variable "network_tier" {
  default = "STANDARD"
}

variable "stack_type" {
  default = "IPV4_ONLY"
}

variable "auto_create_subnetworks" {
  default = false
}

variable "routing_mode" {
  default = "REGIONAL"
}

variable "delete_default_routes_on_create" {
  default = true
}

variable "webapp_subnet_route_dest_range" {
  default = "0.0.0.0/0"
}

variable "webapp_subnet_route_next_hop_gateway" {
  default = "default-internet-gateway"
}

variable "webapp_firewall_name" {
  default = "webapp-firewall"
}

variable "webapp_firewall_protocol" {
  default = "tcp"
}

variable "webapp_firewall_ports" {
  type    = list(string)
  default = ["3000"]
}

variable "webapp-firewall_direction" {
  default = "INGRESS"
}

variable "webapp_firewall_target_tags" {
  type    = list(string)
  default = ["firewall", "webapp"]
}

variable "webapp_firewall_source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "database_version_SQL" {
  default = "MYSQL_8_0"
}

variable "google_sql_database_instance_tier" {
  default = "db-f1-micro"
}

variable "google_sql_database_instance_availability_type" {
  default = "REGIONAL"
}

variable "google_sql_database_instance_disk_type" {
  default = "PD_SSD"
}

variable "google_sql_database_instance_disk_size" {
  default = "100"
}

variable "google_sql_database_instance_backup_configuration_enabled" {
  default = true
}

variable "google_sql_database_instance_backup_configuration_binary_log_enabled" {
  default = true
}

variable "google_sql_database_instance_psc_enabled" {
  default = true
}

variable "google_sql_database_instance_allowed_consumer_projects" {
}

variable "google_sql_database_instance_ipv4_enabled" {
  default = false
}

variable "google_sql_database_instance_deletion_protection" {
  default = false
}

variable "google_compute_address_address_type" {
  default = "INTERNAL"
}

variable "google_compute_address_address" {
  default = "10.0.2.11"
}

variable "google_compute_forwarding_rule_load_balancing_schema" {
  default = ""
}

variable "google_sql_database_name" {
  default = "my-database-test"
}

variable "google_sql_user_name" {
  default = "webapp"
}

variable "PORT" {
  default = 3000
}

variable "google_compute_firewall_db_allow_name" {
  default = "webapp-compute-firewall-allow-db"
}

variable "google_compute_firewall_db_allow_protocol" {
  default = "tcp"
}

variable "google_compute_firewall_db_allow_ports" {
  default = ["3306"]
  type    = list(string)
}

variable "google_compute_firewall_db_allow_direction" {
  default = "EGRESS"
}

variable "google_compute_firewall_others_ingress_deny_name" {
  default = "webapp-compute-firewall-deny-others-ingress"
}

variable "google_compute_firewall_others_ingress_deny_protocol" {
  default = "all"
}

variable "google_compute_firewall_others_ingress_deny_priority" {
  default = 65534
}

variable "google_compute_firewall_others_ingress_deny_direction" {
  default = "INGRESS"
}

variable "google_compute_firewall_others_ingress_deny_source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "google_compute_firewall_others_egress_deny_name" {
  default = "webapp-compute-firewall-deny-others-egress"
}

variable "google_compute_firewall_others_egress_deny_protocol" {
  default = "all"
}

variable "google_compute_firewall_others_egress_deny_priority" {
  default = 65534
}

variable "google_compute_firewall_others_egress_deny_direction" {
  default = "EGRESS"
}
