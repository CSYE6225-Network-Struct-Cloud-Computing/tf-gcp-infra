terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = var.project_id
  region  = var.region
}

# https://discuss.hashicorp.com/t/loop-with-list-map/8878
# https://www.terraformbyexample.com/for/
# https://stackoverflow.com/questions/73452003/terraform-increment-a-variable-in-a-for-each-loop
# locals {
#   config = { for i, vpc_var in var.vpc_name : vpc_var => {
#     webapp_subnet_name = i == 0 ? var.webapp_subnet_name : "${var.webapp_subnet_name}-${vpc_var}"
#     db_subnet_name     = i == 0 ? var.db_subnet_name : "${var.db_subnet_name}-${vpc_var}"
#   } }
# }

# https://stackoverflow.com/questions/75260919/when-to-use-terraform-modules-from-terraform-registry-and-when-to-use-resource
# https://developer.hashicorp.com/terraform/tutorials/modules/module-create
# https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
# https://www.digitalocean.com/community/tutorials/how-to-build-a-custom-terraform-module
module "myvpc" {
  source                                                    = "./vpc-module"
  vpc_name                                                  = var.vpc_name
  webapp_subnet_name                                        = var.webapp_subnet_name
  webapp_subnet_cidr                                        = var.webapp_subnet_cidr
  webapp_subnet_region                                      = var.region
  db_subnet_name                                            = var.db_subnet_name
  db_subnet_cidr                                            = var.db_subnet_cidr
  db_subnet_region                                          = var.region
  auto_create_subnetworks                                   = var.auto_create_subnetworks
  routing_mode                                              = var.routing_mode
  delete_default_routes_on_create                           = var.delete_default_routes_on_create
  webapp_subnet_route_dest_range                            = var.webapp_subnet_route_dest_range
  webapp_subnet_route_next_hop_gateway                      = var.webapp_subnet_route_next_hop_gateway
  webapp_firewall_name                                      = var.webapp_firewall_name
  webapp_firewall_protocol                                  = var.webapp_firewall_protocol
  webapp_firewall_ports                                     = var.webapp_firewall_ports
  webapp-firewall_direction                                 = var.webapp-firewall_direction
  webapp_firewall_target_tags                               = var.webapp_firewall_target_tags
  webapp_firewall_source_ranges                             = var.webapp_firewall_source_ranges
  google_compute_firewall_db_allow_name                     = var.google_compute_firewall_db_allow_name
  google_compute_firewall_db_allow_protocol                 = var.google_compute_firewall_db_allow_protocol
  google_compute_firewall_db_allow_ports                    = var.google_compute_firewall_db_allow_ports
  google_compute_firewall_db_allow_direction                = var.google_compute_firewall_db_allow_direction
  google_compute_firewall_others_ingress_deny_name          = var.google_compute_firewall_others_ingress_deny_name
  google_compute_firewall_others_ingress_deny_protocol      = var.google_compute_firewall_others_ingress_deny_protocol
  google_compute_firewall_others_ingress_deny_priority      = var.google_compute_firewall_others_ingress_deny_priority
  google_compute_firewall_others_ingress_deny_direction     = var.google_compute_firewall_others_ingress_deny_direction
  google_compute_firewall_others_ingress_deny_source_ranges = var.google_compute_firewall_others_ingress_deny_source_ranges
  google_compute_firewall_others_egress_deny_name           = var.google_compute_firewall_others_egress_deny_name
  google_compute_firewall_others_egress_deny_protocol       = var.google_compute_firewall_others_egress_deny_protocol
  google_compute_firewall_others_egress_deny_priority       = var.google_compute_firewall_others_egress_deny_priority
  google_compute_firewall_others_egress_deny_direction      = var.google_compute_firewall_others_egress_deny_direction
  region                                                    = var.region
  google_compute_subnetwork_proxy_only_name                 = var.google_compute_subnetwork_proxy_only_name
  google_compute_subnetwork_proxy_only_ip_cidr_range        = var.google_compute_subnetwork_proxy_only_ip_cidr_range
  google_compute_subnetwork_proxy_only_purpose              = var.google_compute_subnetwork_proxy_only_purpose
  google_compute_subnetwork_proxy_only_role                 = var.google_compute_subnetwork_proxy_only_role
}

# module "vm" {
#   source                = "./vm-module"
#   vm_name               = var.vm_name
#   machine_type          = var.machine_type
#   zone                  = var.zone
#   boot_disk_image       = var.boot_disk_image
#   subnetwork            = module.myvpc.webapp_subnet
#   boot_disk_size        = var.boot_disk_size
#   boot_disk_type        = var.boot_disk_type
#   tags                  = module.myvpc.webapp_firewall_tags
#   network_tier          = var.network_tier
#   stack_type            = var.stack_type
#   PORT                  = var.PORT
#   MYSQL_USERNAME        = module.cloudSQL.db_username
#   MYSQL_PASSWORD        = module.cloudSQL.db_password
#   MYSQL_DB_NAME         = module.cloudSQL.database_name
#   MYSQL_HOST            = module.cloudSQL.internal_ip
#   TEST_MYSQL_DB_NAME    = module.cloudSQL.database_name
#   service_account_email = module.serviceAccount.service_account_email
#   TOPIC_ID              = module.pubsub.pubsub_name
#   PROJECT_ID            = var.project_id
# }

module "cloudSQL" {
  source                                                               = "./cloudsql-module"
  private_network_SQL                                                  = module.myvpc.vpc
  google_compute_address_subnetwork                                    = module.myvpc.db_subnet
  google_compute_forwarding_rule_network                               = module.myvpc.vpc
  database_version_SQL                                                 = var.database_version_SQL
  google_sql_database_instance_tier                                    = var.google_sql_database_instance_tier
  google_sql_database_instance_availability_type                       = var.google_sql_database_instance_availability_type
  google_sql_database_instance_disk_type                               = var.google_sql_database_instance_disk_type
  google_sql_database_instance_disk_size                               = var.google_sql_database_instance_disk_size
  google_sql_database_instance_backup_configuration_enabled            = var.google_sql_database_instance_backup_configuration_enabled
  google_sql_database_instance_backup_configuration_binary_log_enabled = var.google_sql_database_instance_backup_configuration_binary_log_enabled
  google_sql_database_instance_psc_enabled                             = var.google_sql_database_instance_psc_enabled
  google_sql_database_instance_allowed_consumer_projects               = var.google_sql_database_instance_allowed_consumer_projects
  google_sql_database_instance_ipv4_enabled                            = var.google_sql_database_instance_ipv4_enabled
  google_sql_database_instance_deletion_protection                     = var.google_sql_database_instance_deletion_protection
  google_compute_address_address_type                                  = var.google_compute_address_address_type
  google_compute_address_address                                       = var.google_compute_address_address
  google_compute_forwarding_rule_load_balancing_schema                 = var.google_compute_forwarding_rule_load_balancing_schema
  google_sql_database_name                                             = var.google_sql_database_name
  google_sql_user_name                                                 = var.google_sql_user_name
}

module "dns" {
  source = "./dns-module"
  # vm_instance_ip               = module.vm.vm_instance_ip
  google_dns_managed_zone_name = var.google_dns_managed_zone_name
  google_dns_record_set_type   = var.google_dns_record_set_type
  google_dns_record_set_ttl    = var.google_dns_record_set_ttl
  load_balancer_ip             = module.vm-template.load_balancer_ip
}

module "serviceAccount" {
  source                                              = "./serviceAccount-module"
  project_id                                          = var.project_id
  google_service_account_account_id                   = var.google_service_account_account_id
  google_service_account_display_name                 = var.google_service_account_display_name
  google_service_account_description                  = var.google_service_account_description
  google_project_iam_binding_logging_admin            = var.google_project_iam_binding_logging_admin
  google_project_iam_binding_monitoring_metric_writer = var.google_project_iam_binding_monitoring_metric_writer
  google_project_iam_binding_pubsub_publisher         = var.google_project_iam_binding_pubsub_publisher
}

module "pubsub" {
  source                            = "./pub-sub-module"
  pubsub_message_retention_duration = var.pubsub_message_retention_duration
  pubsub_topic_name                 = var.pubsub_topic_name
}

module "vpc_connectors" {
  source                  = "./vpc-connector-module"
  connector_name          = var.connector_name
  connector_region        = var.connector_region
  connector_ip_cidr_range = var.connector_ip_cidr_range
  vpc_network_name        = module.myvpc.vpc
  connector_min_instances = var.connector_min_instances
  connector_max_instances = var.connector_max_instances
  connector_machine_type  = var.connector_machine_type
}

module "cloud_functions" {
  source                                                 = "./cloud_functions"
  bucket_name                                            = var.bucket_name
  bucket_object_name                                     = var.bucket_object_name
  cloud_fun_name                                         = var.cloud_fun_name
  pubsub_id                                              = module.pubsub.pubsub_id
  DB_USERNAME                                            = module.cloudSQL.db_username
  DB_PASSWORD                                            = module.cloudSQL.db_password
  DB_NAME                                                = module.cloudSQL.database_name
  DB_HOST                                                = module.cloudSQL.internal_ip
  cloud_fun_sender                                       = var.cloud_fun_sender
  cloud_fun_subject                                      = var.cloud_fun_subject
  DB_PORT                                                = var.DB_PORT
  DOMAIN_NAME                                            = var.DOMAIN_NAME
  MAILGUN_KEY_API                                        = var.MAILGUN_KEY_API
  webapp_env_PORT                                        = var.PORT_LB
  connector_name                                         = module.vpc_connectors.connector_name
  cloud_fun_ser_acc_account_id                           = var.cloud_fun_ser_acc_account_id
  cloud_fun_ser_acc_display_name                         = var.cloud_fun_ser_acc_display_name
  gcp_project                                            = var.project_id
  google_project_iam_binding_cloud_fun_run_invoker       = var.google_project_iam_binding_cloud_fun_run_invoker
  google_project_iam_binding_cloud_fun_pubsub_subscriber = var.google_project_iam_binding_cloud_fun_pubsub_subscriber
  cloud_fun_ingress_settings                             = var.cloud_fun_ingress_settings
  cloud_fun_available_memory_mb                          = var.cloud_fun_available_memory_mb
  cloud_fun_location                                     = var.cloud_fun_location
  cloud_fun_entry_point                                  = var.cloud_fun_entry_point
  cloud_fun_event_trigger_event_type                     = var.cloud_fun_event_trigger_event_type
  cloud_fun_vpc_connector_egress_settings                = var.cloud_fun_vpc_connector_egress_settings
  cloud_fun_runtime                                      = var.cloud_fun_runtime
  cloud_fun_available_memory                             = var.cloud_fun_available_memory
  cloud_fun_timeout_seconds                              = var.cloud_fun_timeout_seconds
  cloud_fun_max_instance_request_concurrency             = var.cloud_fun_max_instance_request_concurrency
  cloud_fun_available_cpu                                = var.cloud_fun_available_cpu
  cloud_fun_retry_policy                                 = var.cloud_fun_retry_policy
  cloud_fun_trigger_region                               = var.cloud_fun_trigger_region
  cloud_fun_max_instance_count                           = var.cloud_fun_max_instance_count
  cloud_fun_min_instance_count                           = var.cloud_fun_min_instance_count
}

module "vm-template" {
  source             = "./vm-template-module"
  service_account    = module.serviceAccount.service_account_email
  subnetwork         = module.myvpc.webapp_subnet
  PORT               = var.PORT
  PORT_LB            = var.PORT_LB
  MYSQL_USERNAME     = module.cloudSQL.db_username
  MYSQL_PASSWORD     = module.cloudSQL.db_password
  MYSQL_DB_NAME      = module.cloudSQL.database_name
  MYSQL_HOST         = module.cloudSQL.internal_ip
  TEST_MYSQL_DB_NAME = module.cloudSQL.database_name
  TOPIC_ID           = module.pubsub.pubsub_name
  PROJECT_ID         = var.project_id
  tags               = module.myvpc.webapp_firewall_tags
  machine_type       = var.machine_type
  boot_disk_type     = var.boot_disk_type
  boot_disk_size     = var.boot_disk_size
  source_image       = var.boot_disk_image
  vpc_id             = module.myvpc.vpc
  proxy_only_subnet  = module.myvpc.proxy_only_subnet
  project_id         = var.project_id
  region             = var.region
}
