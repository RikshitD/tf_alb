//Application Load Balancer
resource "aws_lb" "test_alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = values(var.pub_snet_ids)


#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "production"
#   }
}

//target group
resource "aws_lb_target_group" "test_target" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

//target group attachment
resource "aws_lb_target_group_attachment" "target_attach" {
  for_each = var.private_ec2_ids
  target_group_arn = aws_lb_target_group.test_target.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "listen_alb" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_target.arn
  }
}



