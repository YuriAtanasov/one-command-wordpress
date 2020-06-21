output "Wordpress_blog_accessible_after_initialization_at" {
  value = "http://${aws_lb.wp_alb.dns_name}"
}