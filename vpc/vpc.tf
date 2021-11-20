resource "aws_vpc" "main" {
  cidr_block       = var.VPC_CIDR_MAIN
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.ENV}-vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "addon" {
  count      = length(var.VPC_CIDR_ADDON)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.VPC_CIDR_ADDON, count.index)
}