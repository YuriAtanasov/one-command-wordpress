### Wordpress LB
resource "aws_lb" "wp_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wordpress_sg.id]
  subnets            = [module.public-subnet-1.subnet_id, module.public-subnet-2.subnet_id]
}

resource "aws_lb_listener" "wp_alb" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_alb_tg.arn
  }
}

resource "aws_lb_target_group" "wp_alb_tg" {
  name     = "wordpress-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.basic_vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "wordpress_instance_1" {
  target_group_arn = aws_lb_target_group.wp_alb_tg.arn
  target_id        = aws_instance.wordpress_node_1.id
}

resource "aws_lb_target_group_attachment" "wordpress_instance_2" {
  target_group_arn = aws_lb_target_group.wp_alb_tg.arn
  target_id        = aws_instance.wordpress_node_2.id
}


### Wordpress instances

resource "aws_instance" "wordpress_node_1" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  subnet_id              = module.public-subnet-1.subnet_id
  key_name               = var.key_name
  private_ip             = "10.189.1.180" // Due to the dependencies between web and database nodes. Not ideal solution but otherwise we go into cycle

  user_data = data.template_file.wordpress_userdata_1.rendered

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "Wordpress Sample Node 1"
  }

  depends_on = [aws_instance.mysql_node, aws_lb.wp_alb]
}

data "template_file" "wordpress_userdata_1" {
  template = file("scripts/wordpress_1.sh")
  vars = {
    wordpress_mysql_password = aws_ssm_parameter.wordpress_mysql_pwd.value
    mysql_ip                 = aws_instance.mysql_node.private_ip
    wordpress_alb            = aws_lb.wp_alb.dns_name
    wordpress_admin_password = aws_ssm_parameter.wordpress_admin_pwd.value
  }
}


resource "aws_instance" "wordpress_node_2" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  subnet_id              = module.public-subnet-2.subnet_id
  key_name               = var.key_name
  private_ip             = "10.189.2.181" // Due to the dependencies between web and database nodes. Not ideal solution but otherwise we go into cycle

  user_data = data.template_file.wordpress_userdata_2.rendered

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "Wordpress Sample Node 2"
  }

  depends_on = [aws_instance.mysql_node, aws_lb.wp_alb]
}

data "template_file" "wordpress_userdata_2" {
  template = file("scripts/wordpress_2.sh")
  vars = {
    wordpress_mysql_password = aws_ssm_parameter.wordpress_mysql_pwd.value
    mysql_ip                 = aws_instance.mysql_node.private_ip
    wordpress_alb            = aws_lb.wp_alb.dns_name
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
    web_ip_1           = "10.189.1.180" // aws_instance.wordpress_node_1.private_ip
    web_ip_2           = "10.189.2.181" // aws_instance.wordpress_node_2.private_ip
  }
}
