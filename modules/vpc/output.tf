output "vpc_id" {
  value = aws_vpc.test_vpc.id
}


# output "privat_snet_ids" {
#   value = { 
#     id_1 = lookup(module.vpc.pri_snet_ids, "pri-snet-1", null), 
#     id_2 = lookup(module.vpc.pri_snet_ids, "pri-snet-2", null)
#     }
# }




output "pri_snet_ids" {
  value = {
    for k, v in aws_subnet.pri_snet : k => v.id
  }
}
output "pub_snet_ids" {
  value = {
    for k, v in aws_subnet.pub_snet : k => v.id
  }
}

output "nat" {
  value = {
    for k, v in aws_nat_gateway.nat_gw : k => v.id
  }
}

# output "nat_ids" {
#   value = { 
#     id_1 = lookup(aws_nat_gateway.nat_gw.id, "pub-snet-1", null), 
#     id_2 = lookup(aws_nat_gateway.nat_gw.id, "pub-snet-2", null)
#     }
# }