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
