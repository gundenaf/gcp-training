variable "vpc_name" {
  description = "Name of the VPC"
}

variable "subnets_cidr" {
  type        = list(string)
  description = "List of subnet CIDR ranges"
}

variable "subnets_names" {
  type        = list(string)
  description = "List of subnet names"
}