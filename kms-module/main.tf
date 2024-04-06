resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = var.sa_cloud_sql_crypto_key
  project  = var.project_id
}

resource "google_kms_key_ring" "default" {
  name     = var.keyring_name
  location = var.region
}

resource "google_kms_crypto_key" "vm-key" {
  name            = var.vm_crypto_key_name
  key_ring        = google_kms_key_ring.default.id
  rotation_period = var.kms_crypto_key_rotation_period

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [google_kms_key_ring.default]
}

resource "google_kms_crypto_key" "sql-key" {
  name            = var.sql_crypto_key_name
  key_ring        = google_kms_key_ring.default.id
  rotation_period = var.kms_crypto_key_rotation_period

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [google_kms_key_ring.default]
}

resource "google_kms_crypto_key" "bucket-key" {
  name            = var.bucket_crypto_key_name
  key_ring        = google_kms_key_ring.default.id
  rotation_period = var.kms_crypto_key_rotation_period

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [google_kms_key_ring.default]
}

resource "google_kms_crypto_key_iam_binding" "bucket_crypto_key" {
  crypto_key_id = google_kms_crypto_key.bucket-key.id
  role          = var.kms_role

  members = [
    "serviceAccount:service-${var.account_no}@gs-project-accounts.iam.gserviceaccount.com",
  ]
}

resource "google_kms_crypto_key_iam_binding" "sql-crypto_key" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.sql-key.id
  role          = var.kms_role

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}