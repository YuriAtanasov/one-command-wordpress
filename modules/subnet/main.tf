resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr
 # availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(map("Name", "${var.vpc_name}_${var.subnet_name}"))
}

resource "aws_route_table_association" "subnet" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = var.route_table_id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}
