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


