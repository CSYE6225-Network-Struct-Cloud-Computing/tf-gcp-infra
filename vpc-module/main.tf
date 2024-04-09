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

#   direction     = var.webapp_firewall_direction
#   target_tags   = var.webapp_firewall_target_tags
#   source_ranges = var.webapp_firewall_source_ranges
# }

resource "google_compute_firewall" "allow_db" {
  name    = var.firewall_db_allow_name
  network = google_compute_network.vpc.id
  allow {
    protocol = var.firewall_db_allow_protocol
    ports    = var.firewall_db_allow_ports
  }

  direction          = var.firewall_db_allow_direction
  target_tags        = var.webapp_firewall_target_tags
  destination_ranges = [var.db_subnet_cidr]
}


resource "google_compute_firewall" "others_ingress_deny" {
  name    = var.firewall_others_ingress_deny_name
  network = google_compute_network.vpc.id

  deny {
    protocol = var.firewall_others_ingress_deny_protocol
  }

  priority      = var.firewall_others_ingress_deny_priority
  direction     = var.firewall_others_ingress_deny_direction
  source_ranges = var.firewall_others_ingress_deny_source_ranges
}

# resource "google_compute_firewall" "others_egress_deny" {
#   name    = var.firewall_others_egress_deny_name
#   network = google_compute_network.vpc.id

#   deny {
#     protocol = var.firewall_others_egress_deny_protocol
#   }

#   priority      = var.firewall_others_egress_deny_priority
#   direction     = var.firewall_others_egress_deny_direction
#   source_ranges = [var.webapp_subnet_cidr]
# }

# https://cloud.google.com/load-balancing/docs/https/setting-up-reg-ext-https-lb
# resource "google_compute_subnetwork" "proxy_only" {
#   name          = var.subnetwork_proxy_only_name
#   ip_cidr_range = var.subnetwork_proxy_only_ip_cidr_range
#   network       = google_compute_network.vpc.id
#   purpose       = var.subnetwork_proxy_only_purpose
#   region        = var.region
#   role          = var.subnetwork_proxy_only_role
# }

# resource "google_compute_firewall" "allow_proxy" {
#   name = var.firewall_allow_proxy_name
#   allow {
#     ports    = var.firewall_allow_proxy_allow_ports
#     protocol = var.firewall_allow_proxy_allow_protocol
#   }

#   direction          = var.firewall_allow_proxy_direction
#   network            = google_compute_network.vpc.id
#   priority           = var.firewall_allow_proxy_priority
#   source_ranges      = [google_compute_subnetwork.webapp_subnet.ip_cidr_range]
#   target_tags        = var.webapp_firewall_target_tags
#   destination_ranges = [google_compute_subnetwork.webapp_subnet.ip_cidr_range]
# }

resource "google_compute_firewall" "allow_gfe" {
  name    = var.firewall_allow_gfe_name
  network = google_compute_network.vpc.id
  allow {
    protocol = var.firewall_allow_gfe_allow_protocol
    ports    = var.firewall_allow_gfe_allow_ports
  }
  target_tags        = var.webapp_firewall_target_tags
  direction          = var.firewall_allow_gfe_direction
  source_ranges      = var.firewall_allow_gfe_source_ranges
  destination_ranges = [var.webapp_subnet_cidr]
}