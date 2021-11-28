resource "aws_lb" "privatelb" {
  name               = "privatelb-${var.ENV}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.privatelb-sg.id]
  subnets            = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS

  enable_deletion_protection = false


  tags = {
    Environment = "privatelb-${var.ENV}"
  }
}


resource "aws_security_group" "privatelb-sg" {
  name        = "privatelb-${var.ENV}"
  description = "privatelb-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "allow all"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = data.terraform_remote_state.vpc.outputs.ALL_VPC_CIDR
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
    Name = "privatelb-${var.ENV}"
  }
}

resource "aws_lb_listener" "privatelb" {
  load_balancer_arn = aws_lb.privatelb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}


