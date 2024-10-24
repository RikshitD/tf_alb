resource "aws_autoscaling_group" "asg" {
  name                      = "asg_name"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  launch_template {
    id = var.launch_temp_id
  }
    vpc_zone_identifier       = values(var.pri_snet_ids)
  target_group_arns = [var.tg_arn]
}

