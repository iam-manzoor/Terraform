variable "requester_vpc_id" {
  type        = string
  description = "The ID of the requester VPC."
}

variable "requester_vpc_cidr" {
  type        = string
  description = "The CIDR block of the requester VPC."
}

variable "requester_route_table_ids" {
  type        = list(string)
  description = "The IDs of the route tables associated with the requester VPC."
}

variable "accepter_vpc_id" {
  type        = string
  description = "The ID of the accepter VPC."
}

variable "accepter_vpc_cidr" {
  type        = string
  description = "The CIDR block of the accepter VPC."
}

variable "accepter_route_table_ids" {
  type        = list(string)
  description = "The IDs of the route tables associated with the accepter VPC."
}