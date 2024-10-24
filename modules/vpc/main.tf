resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

//pub snet
resource "aws_subnet" "pub_snet" {
 for_each = var.pub_snet
 vpc_id = aws_vpc.test_vpc.id
 cidr_block = each.value["cidr_block"]
 availability_zone = each.value["availability_zone"]
 map_public_ip_on_launch = true 
}


//pri snet
resource "aws_subnet" "pri_snet" {
 for_each = var.pri_snet
 vpc_id = aws_vpc.test_vpc.id
 cidr_block = each.value["cidr_block"]
 availability_zone = each.value["availability_zone"]
}



//internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "test_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_rt"
  }

}

resource "aws_route_table_association" "pub_rt_assoc" {
  for_each = aws_subnet.pub_snet
  subnet_id      = each.value.id  
  route_table_id = aws_route_table.public_rt.id 
}


//elastic IP
resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  for_each = var.pub_snet
}




# NAT Gateways
resource "aws_nat_gateway" "nat_gw" {
  for_each = var.pub_snet
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.pub_snet[each.key].id
  # subnet_id = lookup(aws_subnet.pub-snet,var.pub-snet-name, null).id
  tags = {
    Name = "nat-gateway-${each.key}"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.test_vpc.id
  for_each = var.pri_snet

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw[var.pri_to_pub_map[each.key]].id
  }

  tags = {
    Name = "private-rt-${each.key}"
  }
}
// Route Table Association for Private Subnets
resource "aws_route_table_association" "rt_assoc_pri" {
  for_each = var.pri_snet
  subnet_id      = aws_subnet.pri_snet[each.key].id
  route_table_id = aws_route_table.private_rt[each.key].id
}


# resource "aws_route_table_association" "rt_assoc_pri" {
#   for_each = var.pri_snet
#   subnet_id      = aws_subnet.pri-snet[each.key].id
#   route_table_id = aws_route_table.private_rt[each.key].id
# }


# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.test_vpc.id
#   for_each = var.pri_snet

#   dynamic "route" {
#      for_each = lookup(each.value, "pri_rt", [])
#      content {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = lookup(route.value, "nat_gw_id", null)
#   }
#   }

#   tags = {
#     Name = "private-rt-${each.key}"
#   }

# }




