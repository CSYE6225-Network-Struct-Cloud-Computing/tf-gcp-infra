data "google_dns_managed_zone" "default" {
  name = var.google_dns_managed_zone_name
}

resource "google_dns_record_set" "default" {
  name = data.google_dns_managed_zone.default.dns_name
  type = var.google_dns_record_set_type
  ttl  = var.google_dns_record_set_ttl

  managed_zone = data.google_dns_managed_zone.default.name

  rrdatas = [var.load_balancer_ip]
}