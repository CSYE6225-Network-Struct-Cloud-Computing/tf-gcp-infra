variable "project_id" {
}

variable "region" {
  default = "us-east1"
}

variable "vpc_name" {
  default = "myvpc1"
}

variable "webapp_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "webapp_subnet_name" {
  default = "webapp"
}

variable "webapp_subnet_region" {
  default = "us-east1"
}

variable "db_subnet_name" {
  default = "db"
}

variable "db_subnet_region" {
  default = "us-east1"
}

variable "vm_name" {
  default = "vm"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "zone" {
  default = "us-east1-b"
}

variable "boot_disk_image" {
  # Eg boot_disk_image = "projects/"project-id"/global/images/"image-name" "
}

variable "boot_disk_type" {
  default = "pd-standard"
}

variable "tags" {
  type    = list(string)
  default = ["firewall", "webapp"]
}

variable "boot_disk_size" {
  type    = number
  default = 100
}

variable "network_tier" {
  default = "STANDARD"
}

variable "stack_type" {
  default = "IPV4_ONLY"
}

variable "auto_create_subnetworks" {
  default = false
}

variable "routing_mode" {
  default = "REGIONAL"
}

variable "delete_default_routes_on_create" {
  default = true
}

variable "webapp_subnet_route_dest_range" {
  default = "0.0.0.0/0"
}

variable "webapp_subnet_route_next_hop_gateway" {
  default = "default-internet-gateway"
}

variable "webapp_firewall_name" {
  default = "webapp-firewall"
}

variable "webapp_firewall_protocol" {
  default = "tcp"
}

variable "webapp_firewall_ports" {
  type    = list(string)
  default = ["3000"]
}

variable "webapp-firewall_direction" {
  default = "INGRESS"
}

variable "webapp_firewall_target_tags" {
  type    = list(string)
  default = ["firewall", "webapp"]
}

variable "webapp_firewall_source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "database_version_SQL" {
  default = "MYSQL_8_0"
}

variable "google_sql_database_instance_tier" {
  default = "db-f1-micro"
}

variable "google_sql_database_instance_availability_type" {
  default = "REGIONAL"
}

variable "google_sql_database_instance_disk_type" {
  default = "PD_SSD"
}

variable "google_sql_database_instance_disk_size" {
  default = "100"
}

variable "google_sql_database_instance_backup_configuration_enabled" {
  default = true
}

variable "google_sql_database_instance_backup_configuration_binary_log_enabled" {
  default = true
}

variable "google_sql_database_instance_psc_enabled" {
  default = true
}

variable "google_sql_database_instance_allowed_consumer_projects" {
}

variable "google_sql_database_instance_ipv4_enabled" {
  default = false
}

variable "google_sql_database_instance_deletion_protection" {
  default = false
}

variable "google_compute_address_address_type" {
  default = "INTERNAL"
}

variable "google_compute_address_address" {
  default = "10.0.2.11"
}

variable "google_compute_forwarding_rule_load_balancing_schema" {
  default = ""
}

variable "google_sql_database_name" {
  default = "my-database-test"
}

variable "google_sql_user_name" {
  default = "webapp"
}

variable "PORT" {
  default = 3000
}

variable "google_compute_firewall_db_allow_name" {
  default = "webapp-compute-firewall-allow-db"
}

variable "google_compute_firewall_db_allow_protocol" {
  default = "tcp"
}

variable "google_compute_firewall_db_allow_ports" {
  default = ["3306"]
  type    = list(string)
}

variable "google_compute_firewall_db_allow_direction" {
  default = "EGRESS"
}

variable "google_compute_firewall_others_ingress_deny_name" {
  default = "webapp-compute-firewall-deny-others-ingress"
}

variable "google_compute_firewall_others_ingress_deny_protocol" {
  default = "all"
}

variable "google_compute_firewall_others_ingress_deny_priority" {
  default = 65534
}

variable "google_compute_firewall_others_ingress_deny_direction" {
  default = "INGRESS"
}

variable "google_compute_firewall_others_ingress_deny_source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "google_compute_firewall_others_egress_deny_name" {
  default = "webapp-compute-firewall-deny-others-egress"
}

variable "google_compute_firewall_others_egress_deny_protocol" {
  default = "all"
}

variable "google_compute_firewall_others_egress_deny_priority" {
  default = 65534
}

variable "google_compute_firewall_others_egress_deny_direction" {
  default = "EGRESS"
}

variable "google_dns_managed_zone_name" {
  default = "omsolanki"
}

variable "google_dns_record_set_type" {
  default = "A"
}

variable "google_dns_record_set_ttl" {
  default = 300
}

variable "google_service_account_account_id" {
  default = "service-account-logging"
}
variable "google_service_account_display_name" {
  default = "Service Account Logging"
}
variable "google_service_account_description" {
  default = "Created by Terraform for Logging"
}
variable "google_project_iam_binding_logging_admin" {
  default = "roles/logging.admin"
}
variable "google_project_iam_binding_monitoring_metric_writer" {
  default = "roles/monitoring.metricWriter"
}

variable "pubsub_topic_name" {
  default = "mypubsub"
}

variable "pubsub_message_retention_duration" {
  default = "604800s"
}

variable "connector_name" {
  default = "connector-sql"
}

variable "connector_ip_cidr_range" {
  default = "10.8.0.0/28"
}

variable "connector_region" {
  default = "us-east1"
}

variable "connector_machine_type" {
  default = "f1-micro"
}

variable "connector_min_instances" {
  default = "2"
}

variable "connector_max_instances" {
  default = "3"
}

variable "bucket_name" {
  default = "csye-6225-spring-2024-dev-bucket"
}

variable "bucket_object_name" {
  default = "function-source.zip"
}


variable "cloud_fun_name" {
  default = "cloud_fun"
}

variable "DOMAIN_NAME" {
  default = "omsolanki.me"
}

variable "MAILGUN_KEY_API" {
}

variable "cloud_fun_ser_acc_account_id" {
  default = "cloud-func-service-account"
}

variable "cloud_fun_ser_acc_display_name" {
  default = "Email Verification Cloud Function"
}

variable "google_project_iam_binding_cloud_fun_run_invoker" {
  default = "roles/run.invoker"
}

variable "google_project_iam_binding_cloud_fun_pubsub_subscriber" {
  default = "roles/pubsub.subscriber"
}

variable "google_project_iam_binding_pubsub_publisher" {
  default = "roles/pubsub.publisher"
}

variable "cloud_fun_ingress_settings" {
  default = "ALLOW_INTERNAL_ONLY"
}

variable "cloud_fun_event_trigger_event_type" {
  default = "google.cloud.pubsub.topic.v1.messagePublished"
}

variable "cloud_fun_vpc_connector_egress_settings" {
  default = "PRIVATE_RANGES_ONLY"
}

variable "cloud_fun_runtime" {
  default = "nodejs20"
}

variable "cloud_fun_available_memory_mb" {
  default = "128"
}

variable "cloud_fun_location" {
  default = "us-east1"
}

variable "cloud_fun_entry_point" {
  default = "helloPubSub"
}

variable "cloud_fun_max_instance_count" {
  default = "1"
}

variable "cloud_fun_min_instance_count" {
  default = "0"
}

variable "cloud_fun_available_memory" {
  default = "128Mi"
}

variable "cloud_fun_timeout_seconds" {
  default = "60"
}

variable "cloud_fun_max_instance_request_concurrency" {
  default = "1"
}

variable "cloud_fun_available_cpu" {
  default = "1"
}

variable "cloud_fun_trigger_region" {
  default = "us-east1"
}

variable "cloud_fun_retry_policy" {
  default = "RETRY_POLICY_RETRY"
}

variable "DB_PORT" {
  default = 3306
}

variable "cloud_fun_sender" {
  default = "CSYE 6225 <no-reply@omsolanki.me>"
}

variable "cloud_fun_subject" {
  default = "CSYE 6225 - Please Verify your account."
}

variable "PORT_LB" {
  default = 443
}

variable "google_compute_subnetwork_proxy_only_name" {
  default = "proxy-only-subnet"
}

variable "google_compute_subnetwork_proxy_only_ip_cidr_range" {
  default = "10.129.0.0/23"
}

variable "google_compute_subnetwork_proxy_only_purpose" {
  default = "REGIONAL_MANAGED_PROXY"
}

variable "google_compute_subnetwork_proxy_only_role" {
  default = "ACTIVE"
}

