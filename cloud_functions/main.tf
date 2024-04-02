data "google_storage_bucket" "my-bucket" {
  name = var.bucket_name
}

resource "google_service_account" "cloud_fun_ser_acc_account" {
  account_id   = var.cloud_fun_ser_acc_account_id
  display_name = var.cloud_fun_ser_acc_display_name
}

resource "google_project_iam_binding" "cloud_fun_run_invoker" {
  project = var.gcp_project
  role    = var.google_project_iam_binding_cloud_fun_run_invoker

  members = [
    "serviceAccount:${google_service_account.cloud_fun_ser_acc_account.email}",
  ]

  depends_on = [google_service_account.cloud_fun_ser_acc_account]
}

resource "google_project_iam_binding" "cloud_fun_pubsub_subscriber" {
  project = var.gcp_project
  role    = var.google_project_iam_binding_cloud_fun_pubsub_subscriber

  members = [
    "serviceAccount:${google_service_account.cloud_fun_ser_acc_account.email}",
  ]
  depends_on = [google_service_account.cloud_fun_ser_acc_account]
}

resource "google_cloudfunctions2_function" "cloud_fun" {
  name     = var.cloud_fun_name
  location = var.cloud_fun_location

  build_config {
    runtime     = var.cloud_fun_runtime
    entry_point = var.cloud_fun_entry_point

    source {
      storage_source {
        bucket = data.google_storage_bucket.my-bucket.name
        object = var.bucket_object_name
      }
    }
  }

  service_config {
    max_instance_count               = var.cloud_fun_max_instance_count
    min_instance_count               = var.cloud_fun_min_instance_count
    available_memory                 = var.cloud_fun_available_memory
    timeout_seconds                  = var.cloud_fun_timeout_seconds
    max_instance_request_concurrency = var.cloud_fun_max_instance_request_concurrency
    available_cpu                    = var.cloud_fun_available_cpu
    environment_variables = {
      MAILGUN_API_KEY = var.MAILGUN_KEY_API
      domain          = var.DOMAIN_NAME
      port            = var.DB_PORT
      sender          = var.cloud_fun_sender
      subject         = var.cloud_fun_subject
      host            = var.DB_HOST
      user            = var.DB_USERNAME
      password        = var.DB_PASSWORD
      database        = var.DB_NAME
      portapp         = var.webapp_env_PORT
    }
    ingress_settings              = var.cloud_fun_ingress_settings
    vpc_connector                 = var.connector_name
    vpc_connector_egress_settings = var.cloud_fun_vpc_connector_egress_settings

    service_account_email = google_service_account.cloud_fun_ser_acc_account.email
  }

  event_trigger {
    trigger_region        = var.cloud_fun_trigger_region
    event_type            = var.cloud_fun_event_trigger_event_type
    pubsub_topic          = var.pubsub_id
    retry_policy          = var.cloud_fun_retry_policy
    service_account_email = google_service_account.cloud_fun_ser_acc_account.email
  }
}
