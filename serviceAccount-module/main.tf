resource "google_service_account" "default" {
  account_id   = var.google_service_account_account_id
  display_name = var.google_service_account_display_name
  description  = var.google_service_account_description
}

resource "google_project_iam_binding" "logging_admin" {
  project = var.project_id
  role    = var.google_project_iam_binding_logging_admin

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
  depends_on = [google_service_account.default]
}

resource "google_project_iam_binding" "monitoring_metric_writer" {
  project = var.project_id
  role    = var.google_project_iam_binding_monitoring_metric_writer

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
  depends_on = [google_service_account.default]
}

resource "google_project_iam_binding" "pubsub_publisher" {
  project = var.project_id
  role    = var.google_project_iam_binding_pubsub_publisher

  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
  depends_on = [google_service_account.default]
}