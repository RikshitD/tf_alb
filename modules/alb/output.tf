output "target_group_arn" {
    value = aws_lb_target_group.test_target.arn
  
}
output "alb_dns" {
  value = aws_lb.test_alb.dns_name
}