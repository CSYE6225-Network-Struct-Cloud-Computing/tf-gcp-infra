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

# Commented this as now load balancer is handlening this
# resource "google_compute_firewall" "vpc_firewall" {
#   name    = var.webapp_firewall_name
#   network = google_compute_network.vpc.id
#   allow {
#     protocol = var.webapp_firewall_protocol
#     ports    = var.webapp_firewall_ports
#   }

#   direction     = var.webapp-firewall_direction
#   target_tags   = var.webapp_firewall_target_tags
#   source_ranges = var.webapp_firewall_source_ranges
# }

resource "google_compute_firewall" "allow_db" {
  name    = var.google_compute_firewall_db_allow_name
  network = google_compute_network.vpc.id
  allow {
    protocol = var.google_compute_firewall_db_allow_protocol
    ports    = var.google_compute_firewall_db_allow_ports
  }

  direction          = var.google_compute_firewall_db_allow_direction
  target_tags        = var.webapp_firewall_target_tags
  destination_ranges = [var.db_subnet_cidr]
}


resource "google_compute_firewall" "others_ingress_deny" {
  name    = var.google_compute_firewall_others_ingress_deny_name
  network = google_compute_network.vpc.id

  deny {
    protocol = var.google_compute_firewall_others_ingress_deny_protocol
  }

  priority      = var.google_compute_firewall_others_ingress_deny_priority
  direction     = var.google_compute_firewall_others_ingress_deny_direction
  source_ranges = var.google_compute_firewall_others_ingress_deny_source_ranges
}

# resource "google_compute_firewall" "others_egress_deny" {
#   name    = var.google_compute_firewall_others_egress_deny_name
#   network = google_compute_network.vpc.id

#   deny {
#     protocol = var.google_compute_firewall_others_egress_deny_protocol
#   }

#   priority      = var.google_compute_firewall_others_egress_deny_priority
#   direction     = var.google_compute_firewall_others_egress_deny_direction
#   source_ranges = [var.webapp_subnet_cidr]
# }

# https://cloud.google.com/load-balancing/docs/https/setting-up-reg-ext-https-lb
resource "google_compute_subnetwork" "proxy_only" {
  name          = "proxy-only-subnet"
  ip_cidr_range = "10.129.0.0/23"
  network       = google_compute_network.vpc.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  region        = var.region
  role          = "ACTIVE"
}

resource "google_compute_firewall" "default" {
  name = "fw-allow-health-check"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  direction          = "INGRESS"
  network            = google_compute_network.vpc.id
  priority           = 1000
  source_ranges      = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags        = var.webapp_firewall_target_tags
  destination_ranges = [google_compute_subnetwork.webapp_subnet.ip_cidr_range]
}

resource "google_compute_firewall" "allow_proxy" {
  name = "fw-allow-proxies"
  allow {
    ports    = ["3000"]
    protocol = "tcp"
  }

  direction          = "INGRESS"
  network            = google_compute_network.vpc.id
  priority           = 1000
  source_ranges      = [google_compute_subnetwork.proxy_only.ip_cidr_range]
  target_tags        = var.webapp_firewall_target_tags
  destination_ranges = [google_compute_subnetwork.webapp_subnet.ip_cidr_range]
}

resource "google_compute_firewall" "allow_gfe" {
  name    = "fw-allow-google-front-end"
  network = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
  target_tags        = var.webapp_firewall_target_tags
  direction          = "INGRESS"
  source_ranges      = ["130.211.0.0/22", "35.191.0.0/16"]
  destination_ranges = [var.webapp_subnet_cidr]
}