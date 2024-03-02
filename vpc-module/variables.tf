variable "vpc_name" {
}

variable "webapp_subnet_name" {
}

variable "webapp_subnet_region" {
}

variable "webapp_subnet_cidr" {
}

variable "db_subnet_name" {
}

variable "db_subnet_region" {
}

variable "db_subnet_cidr" {
}

variable "auto_create_subnetworks" {
}

variable "routing_mode" {
}

variable "delete_default_routes_on_create" {
}

variable "webapp_firewall_name" {
}

variable "webapp_firewall_protocol" {
}

variable "webapp_firewall_ports" {
  type = list(string)
}

variable "webapp-firewall_direction" {
}

variable "webapp_firewall_target_tags" {
  type = list(string)
}

variable "webapp_firewall_source_ranges" {
  type = list(string)
}

variable "webapp_subnet_route_dest_range" {
}

variable "webapp_subnet_route_next_hop_gateway" {
}

variable "google_compute_firewall_db_allow_name" {
}

variable "google_compute_firewall_db_allow_protocol" {
}

variable "google_compute_firewall_db_allow_ports" {
}

variable "google_compute_firewall_db_allow_direction" {
}

variable "google_compute_firewall_others_ingress_deny_name" {
}

variable "google_compute_firewall_others_ingress_deny_protocol" {
}

variable "google_compute_firewall_others_ingress_deny_priority" {
}

variable "google_compute_firewall_others_ingress_deny_direction" {
}

variable "google_compute_firewall_others_ingress_deny_source_ranges" {
}

variable "google_compute_firewall_others_egress_deny_name" {
}

variable "google_compute_firewall_others_egress_deny_protocol" {
}

variable "google_compute_firewall_others_egress_deny_priority" {
}

variable "google_compute_firewall_others_egress_deny_direction" {
}
