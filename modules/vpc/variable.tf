variable "vpc_cidr" {
  
}
variable "vpc_name" {
  
}

variable "pub_snet" {
  type = map(object({
    cidr_block = string
    availability_zone = string
  }))
}
variable "pri_snet" {
  type = map(object({
    cidr_block = string
    availability_zone = string
  }))
}

variable "pri_to_pub_map" {
  type = map(string)
  default = {
    "pri-snet-1" = "pub-snet-1"
    "pri-snet-2" = "pub-snet-2"
    "pri-snet-3" = "pub-snet-3"
  }
}


# variable "pri_snet" {
#   type = map(object({
#     cidr_block = string
#     availability_zone = string
#     pri_rt = list(object({
#       nat_gw_id = string
#     }))
#   }))
# }