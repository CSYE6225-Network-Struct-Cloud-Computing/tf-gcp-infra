resource "google_service_account" "default" {
  account_id   = "service-account-logging"
  display_name = "Service Account Logging" 
  description = "Created by Terraform for Logging"
}

resource "google_project_iam_binding" "logging_admin" {
  project = "csye-6225-spring-2024-dev"
  role    = "roles/logging.admin"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
  depends_on = [ google_service_account.default ]
}

resource "google_project_iam_binding" "monitoring_metric_writer" {
  project = "csye-6225-spring-2024-dev"
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
  depends_on = [ google_service_account.default ]
}