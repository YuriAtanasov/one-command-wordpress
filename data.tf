provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu_ami" {
  owners = ["099720109477"] // Canonical account ID
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  most_recent = true
}

