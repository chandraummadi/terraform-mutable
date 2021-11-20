resource "aws_eip" "ngw" {
  vpc = true
  tags = {
    Name = "${var.ENV}-ngw-ip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public-subnets.*.id[0]

  tags = {
    Name = "${var.ENV}-ngw"
  }
}
