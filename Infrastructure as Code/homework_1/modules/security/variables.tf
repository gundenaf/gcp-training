variable "ingress_ports" {
  description = "List of ports to open for ingress traffic"
  type        = list(number)
}

variable "source_ip_range" {
  description = "Source IP range for ingress traffic"
  type        = string
}

variable "sg_name" {
  description = "Name of the network"
  type        = string
}

variable "network_name" {
  description = "Name of the network"
  type        = string
}