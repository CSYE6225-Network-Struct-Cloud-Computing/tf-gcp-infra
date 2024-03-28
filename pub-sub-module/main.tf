resource "google_pubsub_topic" "verify_email" {
    name = var.pubsub_topic_name
    message_retention_duration = var.pubsub_message_retention_duration
}

