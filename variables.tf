
variable "aws_region" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "max_az_count" {
  type    = number
  default = 1
}

variable "max_nat_gateway_count" {
  type    = number
  default = 0
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_tags" {
  type    = map(string)
  default = {}
}

variable "internet_gateway_tags" {
  type    = map(string)
  default = {}
}

variable "public_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "public_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "nat_eip_tags" {
  type    = map(string)
  default = {}
}

variable "nat_gateway_tags" {
  type    = map(string)
  default = {}
}

variable "private_route_table_tags" {
  type    = map(string)
  default = {}
}
