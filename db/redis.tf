resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-${var.ENV}"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.redis.name
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis-sg.id]
}

resource "aws_elasticache_parameter_group" "redis" {
  name   = "redis-${var.ENV}"
  family = "redis6.x"
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS

  tags = {
    Name = "redis-${var.ENV}"
  }
}


resource "aws_security_group" "redis-sg" {
  name        = "redis-${var.ENV}"
  description = "redis-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [ {
    description      = "allow redis from main VPC"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = local.ALL_CIDR
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  egress = [{
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
    Name = "redis-${var.ENV}"
  }
}

resource "aws_route53_record" "redis" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "redis-${var.ENV}.roboshop.internal"
  type    = "CNAME"
  ttl     = "300"
  records = aws_elasticache_cluster.redis.cache_nodes.*.address
  allow_overwrite = true
}

