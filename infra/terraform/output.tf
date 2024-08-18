output "alb_dns_name" {
  value       = aws_lb.owtf-alb.dns_name
  description = "The DNS name of the ALB"
}

output "owtf_url" {
  value       = aws_instance.ec2.private_ip
  description = "This provides Private IP of the Instance"
}
