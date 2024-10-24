output "vpc_id" {
  value = module.vpc.vpc_id
}
output "alb_dns" {
  value = module.alb.alb_dns
}

output "privat_snet_ids" {
  value = { 
    id_1 = lookup(module.vpc.pri_snet_ids, "pri-snet-1", null), 
    id_2 = lookup(module.vpc.pri_snet_ids, "pri-snet-2", null)
    id_3 = lookup(module.vpc.pri_snet_ids, "pri-snet-3", null)
    }
}

output "ec2_ids" {
  value = module.ec2.private_ec2_ids
}

# output "nat_ids" {
#   value = { 
#     id_1 = lookup(module.vpc.pri_snet_ids, "pri-snet-1", null), 
#     id_2 = lookup(module.vpc.pri_snet_ids, "pri-snet-2", null),
#     id_3 = lookup(module.vpc.pri_snet_ids, "pri-snet-3", null)
#     }
# }

