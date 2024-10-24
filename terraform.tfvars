region_name = "ap-south-1"
vpc_cidr = "10.0.0.0/16"
vpc_name = "test_vpc"

pub_snet = {
    "pub-snet-1" = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-south-1a"
    },
    "pub-snet-2" = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "ap-south-1b"
    }
    "pub-snet-3" = {
      cidr_block        = "10.0.9.0/24"
      availability_zone = "ap-south-1c"
    }
  }


pri_snet = {
    "pri-snet-1" = {
      cidr_block        = "10.0.15.0/24"
      availability_zone = "ap-south-1a"
    },
    "pri-snet-2" = {
      cidr_block        = "10.0.21.0/24"
      availability_zone = "ap-south-1b"
    }
    "pri-snet-3" = {
      cidr_block        = "10.0.25.0/24"
      availability_zone = "ap-south-1c"
    }
  #   pri_rt = [
  #     nat_gw_id
  #   ]
  }

ec2_names = "webApp-"
key_name = "newchef"
instance_type = "t2.micro"
ami = "ami-0dee22c13ea7a9a67"
ssm_role_name = "SsmRole"
iam_ssm_profile_name = "ssmprofile"
launch_temp_name = "test_temp"
tg_name = "tg1"
alb_name = "alb1"