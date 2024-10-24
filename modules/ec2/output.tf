output "private_ec2_ids" {
  value = { for k, ec2 in aws_instance.private_ec2 : k => ec2.id }
}
output "launch_temp_id" {
  value = aws_launch_template.launch.id
}