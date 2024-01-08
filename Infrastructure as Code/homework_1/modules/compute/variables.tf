variable "machine_type" {
  description = "Compute Engine machine type"
}

variable "disk_size" {
  description = "Google Cloud zone"
}

variable "disk_image" {
  description = "Compute Engine disk image"
}

variable "vm_name" {
  description = "Name of the Compute Engine VM"
}

variable "ssh_username" {
  description = "SSH username for the Compute Engine VM"
}

variable "ssh_public_key" {
  description = "SSH public key for the Compute Engine VM"
}

variable "network_name" {
  description = "The name of the VPC network"
}

variable "zone_name" {
  description = "The name of the VPC network"
}

variable "subnet_name" {
  description = "The name of the private subnet"
}

variable "static_ipv4_address" {
  description = "The name of the static IPv4 address"
}