variable "region" {
  type = "string"
  #default = "ca-central-1"
}

variable "cidr_block" {
  type = "string"
  description = "VPC cidr block"
}

variable "environment" {
  type = "string"
  default = "test"
}

variable "availability_zones" {
  type = "list"
}

variable "bastion_instance_type" {
  type = "string"
}

