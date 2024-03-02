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
  source                               = "./vpc-module"
  vpc_name                             = var.vpc_name
  webapp_subnet_name                   = var.webapp_subnet_name
  webapp_subnet_cidr                   = var.webapp_subnet_cidr
  webapp_subnet_region                 = var.region
  db_subnet_name                       = var.db_subnet_name
  db_subnet_cidr                       = var.db_subnet_cidr
  db_subnet_region                     = var.region
  auto_create_subnetworks              = var.auto_create_subnetworks
  routing_mode                         = var.routing_mode
  delete_default_routes_on_create      = var.delete_default_routes_on_create
  webapp_subnet_route_dest_range       = var.webapp_subnet_route_dest_range
  webapp_subnet_route_next_hop_gateway = var.webapp_subnet_route_next_hop_gateway
  webapp_firewall_name                 = var.webapp_firewall_name
  webapp_firewall_protocol             = var.webapp_firewall_protocol
  webapp_firewall_ports                = var.webapp_firewall_ports
  webapp-firewall_direction            = var.webapp-firewall_direction
  webapp_firewall_target_tags          = var.webapp_firewall_target_tags
  webapp_firewall_source_ranges        = var.webapp_firewall_source_ranges
}

module "vm" {
  source             = "./vm-module"
  vm_name            = var.vm_name
  machine_type       = var.machine_type
  zone               = var.zone
  boot_disk_image    = var.boot_disk_image
  subnetwork         = module.myvpc.webapp_subnet
  boot_disk_size     = var.boot_disk_size
  boot_disk_type     = var.boot_disk_type
  tags               = module.myvpc.webapp_firewall_tags
  network_tier       = var.network_tier
  stack_type         = var.stack_type
  PORT               = var.PORT
  MYSQL_USERNAME     = module.cloudSQL.db_username
  MYSQL_PASSWORD     = module.cloudSQL.db_password
  MYSQL_DB_NAME      = module.cloudSQL.database_name
  MYSQL_HOST         = module.cloudSQL.internal_ip
  TEST_MYSQL_DB_NAME = module.cloudSQL.database_name


  # PORT               = 3000
  # MYSQL_USERNAME     = module.cloudSQL.db_username
  # MYSQL_PASSWORD     = module.cloudSQL.db_password
  # MYSQL_DB_NAME      = module.cloudSQL.database_name
  # MYSQL_HOST         = module.cloudSQL.internal_ip
  # TEST_MYSQL_DB_NAME = module.cloudSQL.database_name
  # startup_script  = <<-EOT
  #     #!/bin/bash  #module.cloudSQL.internal_ip

  #     if [ -e "/opt/webapp/app/.env" ]; then
  #       exit 0
  #     fi

  #     touch /tmp/.env

  #     echo "PORT=${var.PORT}" >> /tmp/.env
  #     echo "MYSQL_USERNAME=${module.cloudSQL.db_username}" >> /tmp/.env
  #     echo "MYSQL_PASSWORD=${module.cloudSQL.db_password}" >> /tmp/.env
  #     echo "MYSQL_DB_NAME=${module.cloudSQL.database_name}" >> /tmp/.env
  #     echo "TEST_MYSQL_DB_NAME=${module.cloudSQL.database_name}" >> /tmp/.env
  #     echo "MYSQL_HOST=${module.cloudSQL.internal_ip}" >> /tmp/.env
  #     echo "NODE_ENV=production" >> /tmp/.env

  #     mv /tmp/.env /home/csye6225/app/.env
  #     chown -R csye6225:csye6225 /home/csye6225/app
  #     chmod -R 764 /home/csye6225/app


  #     EOT



}

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

