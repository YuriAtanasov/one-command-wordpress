resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "aws_eip_nat" {
  value = aws_eip.nat.public_ip
}

output "aws_igw_id" {
  value = aws_internet_gateway.igw.id
}