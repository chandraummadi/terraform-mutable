locals {
  VPC_CIDR_MAIN = split(",", var.VPC_CIDR_MAIN)
  ALL_VPC_CIDR  = concat(local.VPC_CIDR_MAIN, var.VPC_CIDR_ADDON)
}

locals {
  association-list = flatten([
  for cidr in local.ALL_VPC_CIDR : [
  for route_table in tolist(data.aws_route_tables.default-vpc-routes.ids) : {
    cidr        = cidr
    route_table = route_table
  }
  ]
  ])
}
