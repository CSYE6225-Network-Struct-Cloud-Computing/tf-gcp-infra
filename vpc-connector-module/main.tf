resource "google_vpc_access_connector" "connector" {
    name          = var.connector_name
    ip_cidr_range = var.connector_ip_cidr_range
    network       = var.vpc_network_name
    region = var.connector_region
    machine_type = var.connector_machine_type
    min_instances = var.connector_min_instances
    max_instances = var.connector_max_instances
}