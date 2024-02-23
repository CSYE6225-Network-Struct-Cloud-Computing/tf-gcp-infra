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
