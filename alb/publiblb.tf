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

