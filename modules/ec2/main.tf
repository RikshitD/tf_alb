resource "aws_instance" "private_ec2" {
  # Use count to limit the number of instances created
  count = length(var.pri_snet_ids) > 2 ? 2 : length(var.pri_snet_ids) 
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = element(values(var.pri_snet_ids), count.index)  
  vpc_security_group_ids = var.sg_ids

  # NGINX installation script (User Data)
  user_data = <<-EOF
              #!/bin/bash
              # Update the package manager and install NGINX
              sudo apt-get update -y
              sudo apt-get install nginx -y

              # Enable and start NGINX service
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "${var.ec2_names}${count.index + 1}"  # Name instances as ec2_names1, ec2_names2
  }
}


//IAM SSM role
resource "aws_iam_role" "test_ssm_role" {
  name = var.ssm_role_name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "test_ssm_profile" {
  name = var.iam_ssm_profile_name
  role = aws_iam_role.test_ssm_role.name
}

# Attach the AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.test_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}




//ec2 launch template
resource "aws_launch_template" "launch" {
  name = var.launch_temp_name

  iam_instance_profile {
    name = aws_iam_instance_profile.test_ssm_profile.name
  }
  
  vpc_security_group_ids = var.sg_ids
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name

  # Encode user_data as Base64
  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Update the package manager and install NGINX
              sudo apt-get update -y
              sudo apt-get install nginx -y

              # Enable and start NGINX service
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
              )

  tags = {
    Name =  "launch_temp_ec2"
  }
}





# //auto scaling group
# resource "aws_autoscaling_group" "asg" {
#   name                      = "asg_name"
#   max_size                  = 3
#   min_size                  = 1
#   health_check_grace_period = 300
#   health_check_type         = "EC2"
#   desired_capacity          = 2
#   force_delete              = true
#   launch_template {
#     id = aws_launch_template.launch.id
#   }
#     vpc_zone_identifier       = [var.pri_snet_ids[0], var.pri_snet_ids[1], var.pri_snet_ids[2]]
#   target_group_arns = [var.tg_arn]
# #   placement_group           = aws_placement_group.test.id
# #   launch_configuration      = aws_launch_configuration.foobar.name

#   # instance_maintenance_policy {
#   #   min_healthy_percentage = 90
#   #   max_healthy_percentage = 120
#   # }


#   # initial_lifecycle_hook {
#   #   name                 = "foobar"
#   #   default_result       = "CONTINUE"
#   #   heartbeat_timeout    = 2000
#   #   lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

#   #   notification_metadata = jsonencode({
#   #     foo = "bar"
#   #   })

#   #   notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#   #   role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   # }

#   # tag {
#   #   key                 = "foo"
#   #   value               = "bar"
#   #   propagate_at_launch = true
#   # } 


#   # tag {
#   #   key                 = "lorem"
#   #   value               = "ipsum"
#   #   propagate_at_launch = false
#   # }
# }
