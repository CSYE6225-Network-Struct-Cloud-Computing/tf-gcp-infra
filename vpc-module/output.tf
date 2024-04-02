output "webapp_subnet" {
  value = google_compute_subnetwork.webapp_subnet.name
}

output "db_subnet" {
  value = google_compute_subnetwork.db_subnet.name
}

output "vpc" {
  value = google_compute_network.vpc.id
}

output "webapp_firewall_tags" {
  value = var.webapp_firewall_target_tags
}

output "proxy_only_subnet" {
  value = google_compute_subnetwork.proxy_only
}