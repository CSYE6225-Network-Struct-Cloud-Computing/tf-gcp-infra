variable "vm_name" {
}

variable "machine_type" {
}

variable "zone" {
}

variable "boot_disk_image" {
}

variable "boot_disk_type" {
}

variable "tags" {
  type = list(string)
}

variable "boot_disk_size" {
  type = number
}

variable "network_tier" {
}

variable "subnetwork" {
}

variable "stack_type" {
}

# variable "startup_script" {
#   type = string
# }

variable "PORT" {
}

variable "MYSQL_USERNAME" {
}

variable "MYSQL_PASSWORD" {
}

variable "MYSQL_DB_NAME" {
}

variable "TEST_MYSQL_DB_NAME" {
}

variable "MYSQL_HOST" {
}

variable "service_account_email" { 
}

variable "TOPIC_ID" {  
}

variable "PROJECT_ID" {
}
