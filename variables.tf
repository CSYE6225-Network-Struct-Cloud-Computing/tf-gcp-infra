variable "project_id" {
}

variable "region" {
  default = "us-east1"
}

variable "vpc_name" {
  type    = list(string)
  default = ["myvpc1", "myvpc2"]
}

variable "webapp_subnet_cidr" {
}

variable "db_subnet_cidr" {
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
