### root MySQL user password

resource "aws_ssm_parameter" "root_mysql_pwd" {
  name  = "root_mysql_pwd"
  type  = "SecureString"
  value = random_string.root_mysql_pwd.result
}

resource "random_string" "root_mysql_pwd" {
  length  = 16
  special = false
}

### wordpress MySQL user password

resource "aws_ssm_parameter" "wordpress_mysql_pwd" {
  name  = "wordpress_mysql_pwd"
  type  = "SecureString"
  value = random_string.wordpress_mysql_pwd.result
}

resource "random_string" "wordpress_mysql_pwd" {
  length  = 16
  special = false
}

### Wordpress Admin password

resource "aws_ssm_parameter" "wordpress_admin_pwd" {
  name  = "wordpress_admin_pwd"
  type  = "SecureString"
  value = random_string.wordpress_admin_password.result
}

resource "random_string" "wordpress_admin_password" {
  length = 16
  special = false
}