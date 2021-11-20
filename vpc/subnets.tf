resource "aws_subnet" "private-subnets" {
  depends_on        = [aws_vpc_ipv4_cidr_block_association.addon]
  count             = length(var.PRIVATE_SUBNETS)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.PRIVATE_SUBNETS, count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_subnet" "public-subnets" {
  depends_on        = [aws_vpc_ipv4_cidr_block_association.addon]
  count             = length(var.PUBLIC_SUBNETS)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.PUBLIC_SUBNETS, count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "priv-assoc" {
  count          = length(aws_subnet.private-subnets.*.id)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "pub-assoc" {
  count          = length(aws_subnet.public-subnets.*.id)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public-route.id
}
