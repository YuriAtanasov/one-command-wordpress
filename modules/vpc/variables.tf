variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
}

variable "vpc_name" {
  description = "Default Name of the VPC"
  default = "sample basic vpc"
}

variable "vpc_flowlogs_role_name" {
  description = "Defult name for flowlogs IAM role"
}

variable "vpc_flowlogs_policy_name" {
  description = "Default Name for flowlogs IAM policy"
}

variable "vpc_cloudwatch_log_group" {
  description = "Default Name for the Cloudwatch logs log group"
}

