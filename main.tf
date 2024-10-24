module "provider" {
  source = "./modules/provider"
  region_name = var.region_name
}
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  pub_snet = var.pub_snet
  pri_snet = var.pri_snet
 
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}


module "ec2" {
  source = "./modules/ec2"
  ami = var.ami 
  instance_type = var.instance_type
  sg_ids = [module.security_group.sg_id]
  pri_snet_ids = module.vpc.pri_snet_ids
  key_name = var.key_name
  ec2_names = var.ec2_names
  ssm_role_name = var.ssm_role_name
  iam_ssm_profile_name = var.iam_ssm_profile_name
  launch_temp_name = var.launch_temp_name
}


//Application Load Balancer module
module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  alb_sg_id = module.security_group.alb_sg_id
  private_ec2_ids = module.ec2.private_ec2_ids
  pub_snet_ids = module.vpc.pub_snet_ids
  tg_name = var.tg_name
  alb_name = var.alb_name
}

module "asg" {
  source = "./modules/asg"
  tg_arn = module.alb.target_group_arn
  launch_temp_id = module.ec2.launch_temp_id
  pri_snet_ids = module.vpc.pri_snet_ids
}