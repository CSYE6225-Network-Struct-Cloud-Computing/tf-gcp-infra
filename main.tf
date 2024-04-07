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
  source                                     = "./vpc-module"
  vpc_name                                   = var.vpc_name
  webapp_subnet_name                         = var.webapp_subnet_name
  webapp_subnet_cidr                         = var.webapp_subnet_cidr
  webapp_subnet_region                       = var.region
  db_subnet_name                             = var.db_subnet_name
  db_subnet_cidr                             = var.db_subnet_cidr
  db_subnet_region                           = var.region
  auto_create_subnetworks                    = var.auto_create_subnetworks
  routing_mode                               = var.routing_mode
  delete_default_routes_on_create            = var.delete_default_routes_on_create
  webapp_subnet_route_dest_range             = var.webapp_subnet_route_dest_range
  webapp_subnet_route_next_hop_gateway       = var.webapp_subnet_route_next_hop_gateway
  webapp_firewall_name                       = var.webapp_firewall_name
  webapp_firewall_protocol                   = var.webapp_firewall_protocol
  webapp_firewall_ports                      = var.webapp_firewall_ports
  webapp_firewall_direction                  = var.webapp_firewall_direction
  webapp_firewall_target_tags                = var.webapp_firewall_target_tags
  webapp_firewall_source_ranges              = var.webapp_firewall_source_ranges
  firewall_db_allow_name                     = var.firewall_db_allow_name
  firewall_db_allow_protocol                 = var.firewall_db_allow_protocol
  firewall_db_allow_ports                    = var.firewall_db_allow_ports
  firewall_db_allow_direction                = var.firewall_db_allow_direction
  firewall_others_ingress_deny_name          = var.firewall_others_ingress_deny_name
  firewall_others_ingress_deny_protocol      = var.firewall_others_ingress_deny_protocol
  firewall_others_ingress_deny_priority      = var.firewall_others_ingress_deny_priority
  firewall_others_ingress_deny_direction     = var.firewall_others_ingress_deny_direction
  firewall_others_ingress_deny_source_ranges = var.firewall_others_ingress_deny_source_ranges
  firewall_others_egress_deny_name           = var.firewall_others_egress_deny_name
  firewall_others_egress_deny_protocol       = var.firewall_others_egress_deny_protocol
  firewall_others_egress_deny_priority       = var.firewall_others_egress_deny_priority
  firewall_others_egress_deny_direction      = var.firewall_others_egress_deny_direction
  region                                     = var.region
  subnetwork_proxy_only_name                 = var.subnetwork_proxy_only_name
  subnetwork_proxy_only_ip_cidr_range        = var.subnetwork_proxy_only_ip_cidr_range
  subnetwork_proxy_only_purpose              = var.subnetwork_proxy_only_purpose
  subnetwork_proxy_only_role                 = var.subnetwork_proxy_only_role
  firewall_health_check_name                 = var.firewall_health_check_name
  firewall_health_check_allow_protocol       = var.firewall_health_check_allow_protocol
  firewall_health_check_allow_ports          = var.firewall_health_check_allow_ports
  firewall_health_check_direction            = var.firewall_health_check_direction
  firewall_health_check_priority             = var.firewall_health_check_priority
  firewall_health_check_source_ranges        = var.firewall_health_check_source_ranges
  firewall_allow_proxy_name                  = var.firewall_allow_proxy_name
  firewall_allow_proxy_allow_ports           = var.firewall_allow_proxy_allow_ports
  firewall_allow_proxy_allow_protocol        = var.firewall_allow_proxy_allow_protocol
  firewall_allow_proxy_direction             = var.firewall_allow_proxy_direction
  firewall_allow_proxy_priority              = var.firewall_allow_proxy_priority
  firewall_allow_gfe_name                    = var.firewall_allow_gfe_name
  firewall_allow_gfe_allow_protocol          = var.firewall_allow_gfe_allow_protocol
  firewall_allow_gfe_allow_ports             = var.firewall_allow_gfe_allow_ports
  firewall_allow_gfe_direction               = var.firewall_allow_gfe_direction
  firewall_allow_gfe_source_ranges           = var.firewall_allow_gfe_source_ranges
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
  source                                        = "./cloudsql-module"
  private_network_SQL                           = module.myvpc.vpc
  compute_address_subnetwork                    = module.myvpc.db_subnet
  compute_forwarding_rule_network               = module.myvpc.vpc
  database_version_SQL                          = var.database_version_SQL
  sql_tier                                      = var.sql_tier
  sql_availability_type                         = var.sql_availability_type
  sql_disk_type                                 = var.sql_disk_type
  sql_disk_size                                 = var.sql_disk_size
  sql_backup_configuration_enabled              = var.sql_backup_configuration_enabled
  sql_backup_configuration_binary_log_enabled   = var.sql_backup_configuration_binary_log_enabled
  sql_psc_enabled                               = var.sql_psc_enabled
  sql_ipv4_enabled                              = var.sql_ipv4_enabled
  sql_deletion_protection                       = var.sql_deletion_protection
  compute_address_address_type                  = var.compute_address_address_type
  compute_address_address                       = var.compute_address_address
  compute_forwarding_rule_load_balancing_schema = var.compute_forwarding_rule_load_balancing_schema
  google_sql_database_name                      = var.google_sql_database_name
  google_sql_user_name                          = var.google_sql_user_name
  crypto_sql_key_id                             = module.kms.crypto_sql_key_id
  project_id                                    = var.project_id
  depends_on                                    = [module.kms]
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
  source                                       = "./serviceAccount-module"
  project_id                                   = var.project_id
  google_service_account_account_id            = var.google_service_account_account_id
  google_service_account_display_name          = var.google_service_account_display_name
  google_service_account_description           = var.google_service_account_description
  project_iam_binding_logging_admin            = var.project_iam_binding_logging_admin
  project_iam_binding_monitoring_metric_writer = var.project_iam_binding_monitoring_metric_writer
  project_iam_binding_pubsub_publisher         = var.project_iam_binding_pubsub_publisher
  vm_crypto_key                                = module.kms.crypto_vm_key_id
  account_no                                   = var.account_no
  kms_role                                     = var.kms_role
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
  source                                          = "./cloud_functions"
  bucket_name                                     = var.bucket_name
  bucket_object_name                              = var.bucket_object_name
  cloud_fun_name                                  = var.cloud_fun_name
  pubsub_id                                       = module.pubsub.pubsub_id
  DB_USERNAME                                     = module.cloudSQL.db_username
  DB_PASSWORD                                     = module.cloudSQL.db_password
  DB_NAME                                         = module.cloudSQL.database_name
  DB_HOST                                         = module.cloudSQL.internal_ip
  cloud_fun_sender                                = var.cloud_fun_sender
  cloud_fun_subject                               = var.cloud_fun_subject
  DB_PORT                                         = var.DB_PORT
  DOMAIN_NAME                                     = var.DOMAIN_NAME
  MAILGUN_KEY_API                                 = var.MAILGUN_KEY_API
  webapp_env_PORT                                 = var.PORT_LB
  connector_name                                  = module.vpc_connectors.connector_name
  cloud_fun_ser_acc_account_id                    = var.cloud_fun_ser_acc_account_id
  cloud_fun_ser_acc_display_name                  = var.cloud_fun_ser_acc_display_name
  gcp_project                                     = var.project_id
  project_iam_binding_cloud_fun_run_invoker       = var.project_iam_binding_cloud_fun_run_invoker
  project_iam_binding_cloud_fun_pubsub_subscriber = var.project_iam_binding_cloud_fun_pubsub_subscriber
  cloud_fun_ingress_settings                      = var.cloud_fun_ingress_settings
  cloud_fun_available_memory_mb                   = var.cloud_fun_available_memory_mb
  cloud_fun_location                              = var.cloud_fun_location
  cloud_fun_entry_point                           = var.cloud_fun_entry_point
  cloud_fun_event_trigger_event_type              = var.cloud_fun_event_trigger_event_type
  cloud_fun_vpc_connector_egress_settings         = var.cloud_fun_vpc_connector_egress_settings
  cloud_fun_runtime                               = var.cloud_fun_runtime
  cloud_fun_available_memory                      = var.cloud_fun_available_memory
  cloud_fun_timeout_seconds                       = var.cloud_fun_timeout_seconds
  cloud_fun_max_instance_request_concurrency      = var.cloud_fun_max_instance_request_concurrency
  cloud_fun_available_cpu                         = var.cloud_fun_available_cpu
  cloud_fun_retry_policy                          = var.cloud_fun_retry_policy
  cloud_fun_trigger_region                        = var.cloud_fun_trigger_region
  cloud_fun_max_instance_count                    = var.cloud_fun_max_instance_count
  cloud_fun_min_instance_count                    = var.cloud_fun_min_instance_count
  bucket_crypto_key_id                            = module.kms.crypto_bucket_key_id
}

module "vm-template" {
  source                                           = "./vm-template-module"
  service_account                                  = module.serviceAccount.service_account_email
  subnetwork                                       = module.myvpc.webapp_subnet
  PORT                                             = var.PORT
  PORT_LB                                          = var.PORT_LB
  MYSQL_USERNAME                                   = module.cloudSQL.db_username
  MYSQL_PASSWORD                                   = module.cloudSQL.db_password
  MYSQL_DB_NAME                                    = module.cloudSQL.database_name
  MYSQL_HOST                                       = module.cloudSQL.internal_ip
  TEST_MYSQL_DB_NAME                               = module.cloudSQL.database_name
  TOPIC_ID                                         = module.pubsub.pubsub_name
  PROJECT_ID                                       = var.project_id
  tags                                             = module.myvpc.webapp_firewall_tags
  machine_type                                     = var.machine_type
  boot_disk_type                                   = var.boot_disk_type
  boot_disk_size                                   = var.boot_disk_size
  source_image                                     = var.boot_disk_image
  vpc_id                                           = module.myvpc.vpc
  webapp_subnet_full                               = module.myvpc.webapp_subnet_full
  project_id                                       = var.project_id
  region                                           = var.region
  instance_template_name                           = var.instance_template_name
  instance_template_disk_auto_delete               = var.instance_template_disk_auto_delete
  instance_template_disk_boot                      = var.instance_template_disk_boot
  instance_template_network_interface_network_tier = var.instance_template_network_interface_network_tier
  autoscaler_name                                  = var.autoscaler_name
  autoscaler_autoscaling_policy_max_replicas       = var.autoscaler_autoscaling_policy_max_replicas
  autoscaler_autoscaling_policy_min_replicas       = var.autoscaler_autoscaling_policy_min_replicas
  autoscaler_autoscaling_policy_cooldown_period    = var.autoscaler_autoscaling_policy_cooldown_period
  autoscaler_cpu_utilization_target                = var.autoscaler_cpu_utilization_target
  group_manager_name                               = var.group_manager_name
  group_manager_named_port_name                    = var.group_manager_named_port_name
  group_manager_named_port_port                    = var.group_manager_named_port_port
  group_manager_version_name                       = var.group_manager_version_name
  group_manager_base_instance_name                 = var.group_manager_base_instance_name
  group_manager_auto_healing_initial_delay_sec     = var.group_manager_auto_healing_initial_delay_sec
  lb_compute_address_name                          = var.lb_compute_address_name
  lb_compute_address_address_type                  = var.lb_compute_address_address_type
  lb_compute_address_network_tier                  = var.lb_compute_address_network_tier
  health_check_name                                = var.health_check_name
  health_check_check_interval_sec                  = var.health_check_check_interval_sec
  health_check_healthy_threshold                   = var.health_check_healthy_threshold
  health_check_timeout_sec                         = var.health_check_timeout_sec
  health_check_unhealthy_threshold                 = var.health_check_unhealthy_threshold
  health_check_http_health_chec_request_path       = var.health_check_http_health_chec_request_path
  health_check_http_health_check_port              = var.health_check_http_health_check_port
  health_check_http_health_check_host              = var.health_check_http_health_check_host
  health_check_log_config_enable                   = var.health_check_log_config_enable
  backend_service_name                             = var.backend_service_name
  backend_service_load_balancing_scheme            = var.backend_service_load_balancing_scheme
  backend_service_locality_lb_policy               = var.backend_service_locality_lb_policy
  backend_service_protocol                         = var.backend_service_protocol
  backend_service_session_affinity                 = var.backend_service_session_affinity
  backend_service_timeout_sec                      = var.backend_service_timeout_sec
  backend_service_backend_balancing_mode           = var.backend_service_backend_balancing_mode
  backend_service_backend_capacity_scaler          = var.backend_service_backend_capacity_scaler
  backend_service_log_config_enable                = var.backend_service_log_config_enable
  backend_service_log_config_sample_rate           = var.backend_service_log_config_sample_rate
  url_map_name                                     = var.url_map_name
  target_http_proxy_name                           = var.target_http_proxy_name
  lb_forwarding_rule_name                          = var.lb_forwarding_rule_name
  lb_forwarding_rule_ip_protocol                   = var.lb_forwarding_rule_ip_protocol
  lb_forwarding_rule_load_balancing_scheme         = var.lb_forwarding_rule_load_balancing_scheme
  lb_forwarding_rule_port_range                    = var.lb_forwarding_rule_port_range
  lb_forwarding_rule_network_tier                  = var.lb_forwarding_rule_network_tier
  DOMAIN_NAME                                      = var.DOMAIN_NAME
  ssl-certificate-name                             = var.ssl-certificate-name
  crypto_vm_key_id                                 = module.kms.crypto_vm_key_id
}

import {
  id = "projects/${var.project_id}/locations/${var.region}/keyRings/${var.keyring_name}"
  to = module.kms.google_kms_key_ring.default
}

import {
  id = "projects/${var.project_id}/locations/${var.region}/keyRings/${var.keyring_name}/cryptoKeys/${var.vm_crypto_key_name}"
  to = module.kms.google_kms_crypto_key.vm-key
}

import {
  id = "projects/${var.project_id}/locations/${var.region}/keyRings/${var.keyring_name}/cryptoKeys/${var.sql_crypto_key_name}"
  to = module.kms.google_kms_crypto_key.sql-key
}

import {
  id = "projects/${var.project_id}/locations/${var.region}/keyRings/${var.keyring_name}/cryptoKeys/${var.bucket_crypto_key_name}"
  to = module.kms.google_kms_crypto_key.bucket-key
}

module "kms" {
  source                         = "./kms-module"
  vm_crypto_key_name             = var.vm_crypto_key_name
  keyring_name                   = var.keyring_name
  bucket_crypto_key_name         = var.bucket_crypto_key_name
  sql_crypto_key_name            = var.sql_crypto_key_name
  region                         = var.region
  project_id                     = var.project_id
  kms_crypto_key_rotation_period = var.kms_crypto_key_rotation_period
  account_no                     = var.account_no
  kms_role                       = var.kms_role
  sa_cloud_sql_crypto_key        = var.sa_cloud_sql_crypto_key
}
