output "Wordpress_blog_accessible_after_initialization_at" {
  value = "http://${aws_eip.wordpress_eip.public_ip}"
}