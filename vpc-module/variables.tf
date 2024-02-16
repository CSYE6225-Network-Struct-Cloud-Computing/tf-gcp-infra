variable "vpc_name" {
  default = "myvpc_default"
}

variable "webapp_subnet_name" {
  default = "webapp"
}

variable "webapp_subnet_region" {
  default = "us-east1"
}

variable "webapp_subnet_cidr" {
}

variable "db_subnet_name" {
  default = "db"
}

variable "db_subnet_region" {
  default = "us-east1"
}

variable "db_subnet_cidr" {
}