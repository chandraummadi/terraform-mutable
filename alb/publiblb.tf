resource "aws_lb" "publiclb" {
  name               = "publiclb-${var.ENV}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.publiclb-sg.id]
  subnets            = data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNETS_IDS

  enable_deletion_protection = false


  tags = {
    Environment = "publiclb-${var.ENV}"
  }
}


resource "aws_security_group" "publiclb-sg" {
  name        = "publiclb-${var.ENV}"
  description = "publiclb-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "allow all"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }]

  egress = [ {
    description      = " outgoing "
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = "publiclb-${var.ENV}"
  }
}