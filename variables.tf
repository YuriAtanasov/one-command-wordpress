variable "region" {
  default = "eu-west-1" // Should work in all regions however is tested only in Stockholm and Ireland
}

variable "instance_type" {
  default = "t3.micro" // Change if the region does not support that instance type
}

variable "key_name" {
  description = "Already existing EC2 Key pair name used for SSH"
  default = ""
}

### VPC

variable "vpc_cidr" {
  description = "The CIDR range of the VPC. Best practice is to choose the biggest possible network"
  default     = "10.189.0.0/16" // Just sample CIDR, change it if you want or if you have overlapping network. Don't forget to change the subnet CIDRs and wordpress private ip in that case as well.
}

variable "cw_log_group" {
  description = "THe CloudWatch Logs group used for storing VPC flow logs"
  default     = "wordpress-cw-logs-group"
}

variable "fl_policy_name" {
  description = "The name of the flow logs policy"
  default     = "wordpress-fl-policy"
}

variable "fl_role_name" {
  description = "The IAM role used for VPC Flow Logs"
  default     = "wordpress-fl-role"
}