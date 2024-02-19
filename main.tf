terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google"   {
  project = var.project_id
  region  = var.region
}

# https://discuss.hashicorp.com/t/loop-with-list-map/8878
# https://www.terraformbyexample.com/for/
# https://stackoverflow.com/questions/73452003/terraform-increment-a-variable-in-a-for-each-loop
locals {
  config = { for i, vpc_var in var.vpc_name : vpc_var => {
    webapp_subnet_name = i == 0 ? var.webapp_subnet_name : "${var.webapp_subnet_name}-${vpc_var}"
    db_subnet_name     = i == 0 ? var.db_subnet_name : "${var.db_subnet_name}-${vpc_var}"
  } }
}

# https://stackoverflow.com/questions/75260919/when-to-use-terraform-modules-from-terraform-registry-and-when-to-use-resource
# https://developer.hashicorp.com/terraform/tutorials/modules/module-create
# https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
# https://www.digitalocean.com/community/tutorials/how-to-build-a-custom-terraform-module
module "myvpc" {
  for_each             = local.config
  source               = "./vpc-module"
  vpc_name             = each.key
  webapp_subnet_name   = each.value.webapp_subnet_name
  webapp_subnet_cidr   = var.webapp_subnet_cidr
  webapp_subnet_region = var.region
  db_subnet_name       = each.value.db_subnet_name
  db_subnet_cidr       = var.db_subnet_cidr
  db_subnet_region     = var.region
}
