resource "aws_vpc" "main" {
  cidr_block       = var.VPC_CIDR_MAIN

  tags = {
    Name = "${var.ENV}-vpc"
  }
}