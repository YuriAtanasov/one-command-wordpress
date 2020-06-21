### Invoking very basic VPC module

module "basic_vpc" {
  source = "./modules/vpc"

  vpc_cidr                 = var.vpc_cidr
  vpc_cloudwatch_log_group = var.cw_log_group
  vpc_flowlogs_policy_name = var.fl_policy_name
  vpc_flowlogs_role_name   = var.fl_role_name
}

### Public subnets and routes

module "public-subnet-1" {
  source = "./modules/subnet"

  map_public_ip_on_launch = true
  route_table_id          = aws_route_table.public-rt.id
  subnet_cidr             = "10.189.1.0/24"
  subnet_name             = "public-subnet-1"
  vpc_id                  = module.basic_vpc.vpc_id
  availability_zone       = "${var.region}a"
}

module "public-subnet-2" {
  source = "./modules/subnet"

  map_public_ip_on_launch = true
  route_table_id          = aws_route_table.public-rt.id
  subnet_cidr             = "10.189.2.0/24"
  subnet_name             = "public-subnet-2"
  vpc_id                  = module.basic_vpc.vpc_id
  availability_zone       = "${var.region}b"
}

resource "aws_route_table" "public-rt" {
  vpc_id = module.basic_vpc.vpc_id

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route" "public-rt" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.gateways.aws_igw_id

  depends_on = [module.gateways.aws_igw_id]
}

### Private subnets and routes

module "private-subnet-1" {
  source = "./modules/subnet"

  map_public_ip_on_launch = false
  route_table_id          = aws_route_table.private-rt.id
  subnet_cidr             = "10.189.3.0/24"
  subnet_name             = "private-subnet-1"
  vpc_id                  = module.basic_vpc.vpc_id
  availability_zone       = "${var.region}a"
}

module "private-subnet-2" {
  source = "./modules/subnet"

  map_public_ip_on_launch = false
  route_table_id          = aws_route_table.private-rt.id
  subnet_cidr             = "10.189.4.0/24"
  subnet_name             = "private-subnet-1"
  vpc_id                  = module.basic_vpc.vpc_id
  availability_zone       = "${var.region}b"
}

resource "aws_route_table" "private-rt" {
  vpc_id = module.basic_vpc.vpc_id

  tags = {
    Name = "Private route table"
  }
}

resource "aws_route" "private-rt" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.gateways.nat_gateway_id
}

### IGW & NAT Gateway

module "gateways" {
  source    = "./modules/gateways"
  subnet_id = module.public-subnet-1.subnet_id
  vpc_id    = module.basic_vpc.vpc_id
}


### Wordpress SG

resource "aws_security_group" "wordpress_sg" {
  name   = "wordpress_sg"
  vpc_id = module.basic_vpc.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3306
    protocol  = "tcp"
    to_port   = 3306
    self      = true
  }

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    self      = true
  }

  /*  ingress { ### Provide your IP address, uncomment and apply if you need management access to the EC2 machines ###
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [""]
  }*/

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}