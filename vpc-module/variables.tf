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

variable "webapp_firewall_direction" {
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

variable "firewall_db_allow_name" {
}

variable "firewall_db_allow_protocol" {
}

variable "firewall_db_allow_ports" {
}

variable "firewall_db_allow_direction" {
}

variable "firewall_others_ingress_deny_name" {
}

variable "firewall_others_ingress_deny_protocol" {
}

variable "firewall_others_ingress_deny_priority" {
}

variable "firewall_others_ingress_deny_direction" {
}

variable "firewall_others_ingress_deny_source_ranges" {
}

variable "firewall_others_egress_deny_name" {
}

variable "firewall_others_egress_deny_protocol" {
}

variable "firewall_others_egress_deny_priority" {
}

variable "firewall_others_egress_deny_direction" {
}

variable "region" {
}

variable "subnetwork_proxy_only_name" {
}

variable "subnetwork_proxy_only_ip_cidr_range" {
}

variable "subnetwork_proxy_only_purpose" {
}

variable "subnetwork_proxy_only_role" {
}

variable "firewall_health_check_name" {
}

variable "firewall_health_check_allow_protocol" {
}

variable "firewall_health_check_allow_ports" {
  type = list(string)
}

variable "firewall_health_check_direction" {
}

variable "firewall_health_check_priority" {
}

variable "firewall_health_check_source_ranges" {
  type = list(string)
}

variable "firewall_allow_proxy_name" {
}

variable "firewall_allow_proxy_allow_ports" {
  type = list(string)
}

variable "firewall_allow_proxy_allow_protocol" {
}

variable "firewall_allow_proxy_direction" {
}

variable "firewall_allow_proxy_priority" {
}

variable "firewall_allow_gfe_name" {
}

variable "firewall_allow_gfe_allow_protocol" {
}

variable "firewall_allow_gfe_allow_ports" {
  type = list(string)
}

variable "firewall_allow_gfe_direction" {
}

variable "firewall_allow_gfe_source_ranges" {
  type = list(string)
}
