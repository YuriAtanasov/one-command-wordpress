### Wordpress instance

resource "aws_instance" "wordpress_node_1" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  subnet_id              = module.public-subnet-1.subnet_id
  key_name               = var.key_name
  private_ip             = "10.189.1.180" // Due to the dependencies between web and database nodes. Not ideal solution but otherwise we go into cycle

  user_data = data.template_file.wordpress_userdata.rendered

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "Wordpress Sample"
  }

  depends_on = [aws_instance.mysql_node]
}

resource "aws_eip" "wordpress_eip" {
  vpc                       = true

  depends_on = [module.gateways.aws_igw_id]
}

resource "aws_eip_association" "wordpress_eip" {
  instance_id = aws_instance.wordpress_node_1.id
  allocation_id = aws_eip.wordpress_eip.id
}

data "template_file" "wordpress_userdata" {
  template = file("scripts/wordpress.sh")
  vars = {
    wordpress_mysql_password = aws_ssm_parameter.wordpress_mysql_pwd.value
    mysql_ip             = aws_instance.mysql_node.private_ip
    wordpress_eip = aws_eip.wordpress_eip.public_ip
    wordpress_admin_password = aws_ssm_parameter.wordpress_admin_pwd.value
  }
}

### MySQL instance

resource "aws_instance" "mysql_node" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  subnet_id              = module.private-subnet-1.subnet_id
  key_name               = var.key_name

  user_data = data.template_file.mysql_userdata.rendered

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "MySQL Sample"
  }

  depends_on = [module.gateways.nat_gateway_id]
}

data "template_file" "mysql_userdata" {
  template = file("scripts/mysql.sh")
  vars = {
    root_password      = aws_ssm_parameter.root_mysql_pwd.value
    wordpress_password = aws_ssm_parameter.wordpress_mysql_pwd.value
    web_ip             = "10.189.1.180"
  }
}
