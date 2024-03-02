# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc" {
  name                            = var.vpc_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.webapp_subnet_name
  ip_cidr_range = var.webapp_subnet_cidr
  region        = var.webapp_subnet_region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  ip_cidr_range = var.db_subnet_cidr
  region        = var.db_subnet_region
  network       = google_compute_network.vpc.id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route
# https://github.com/hashicorp/terraform-provider-google/issues/16451
resource "google_compute_route" "webapp_subnet_route" {
  name             = "route-${var.webapp_subnet_name}"
  dest_range       = var.webapp_subnet_route_dest_range
  network          = google_compute_network.vpc.id
  next_hop_gateway = var.webapp_subnet_route_next_hop_gateway
}

resource "google_compute_firewall" "vpc_firewall" {
  name    = var.webapp_firewall_name
  network = google_compute_network.vpc.id
  allow {
    protocol = var.webapp_firewall_protocol
    ports    = var.webapp_firewall_ports
  }

  direction     = var.webapp-firewall_direction
  target_tags   = var.webapp_firewall_target_tags
  source_ranges = var.webapp_firewall_source_ranges
}

resource "google_compute_firewall" "allow_db" {
  name    = "webapp-compute-firewall-allow-db"
  network = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  direction          = "EGRESS"
  target_tags        = var.webapp_firewall_target_tags
  destination_ranges = [var.db_subnet_cidr]
}


resource "google_compute_firewall" "others_ingress_deny" {
  name    = "webapp-compute-firewall-deny-others-ingress"
  network = google_compute_network.vpc.id

  deny {
    protocol = "all"
  }

  priority      = 65534
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "others_egress_deny" {
  name    = "webapp-compute-firewall-deny-others-egress"
  network = google_compute_network.vpc.id

  deny {
    protocol = "all"
  }

  priority      = 65534
  direction     = "EGRESS"
  source_ranges = [var.webapp_subnet_cidr]
}
