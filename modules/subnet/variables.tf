variable "vpc_id" {
  description = "Main vpc id"
}

variable "vpc_name" {
  description = "Main vpc name"
  default = "sample basic vpc"
}

variable "subnet_cidr" {
  description = "CIDR for the subnet"
}

/*variable "availability_zone" {
  description = "AZ for the subnet"
}*/

variable "subnet_name" {
  description = "Name for the subnet used as part of the name tag"
}

variable "route_table_id" {
  description = "Route_Table_ID to be associated with the Subnet"
}

variable "map_public_ip_on_launch" {
  description = "map_public_ip_on_launch true/false"
}
