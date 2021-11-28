resource "aws_db_instance" "mysql" {
  identifier = "mysql${var.ENV}"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "mysql${var.ENV}"
  username               = local.rds_user
  password               = local.rds_pass
  parameter_group_name   = aws_db_parameter_group.db-pg.name
  vpc_security_group_ids = [aws_security_group.mysql-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql-subnet.name
  skip_final_snapshot    = true

}


resource "aws_db_parameter_group" "db-pg" {
  name   = "mysql${var.ENV}pg"
  family = "mysql5.7"

}

resource "aws_security_group" "mysql-sg" {
  name        = "mysql-sg-${var.ENV}"
  description = "mysql-sg-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
    description      = "allow mysql from main VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = local.ALL_CIDR
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
    Name = "mysql-sg-${var.ENV}"
  }
}

resource "aws_db_subnet_group" "mysql-subnet" {
  name       = "mysql-subnet-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS

  tags = {
    Name = "mysql-subnet-${var.ENV}"
  }
}

resource "aws_route53_record" "mysql" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "mysql-${var.ENV}.roboshop.internal"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.mysql.address]
  allow_overwrite = true
}

resource "null_resource" "schema-apply" {
  depends_on = [aws_route53_record.mysql]
  provisioner "local-exec" {
    command = <<EOF
sudo yum install mariadb -y
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
unzip -o /tmp/mysql.zip
mysql -h${aws_route53_record.mysql.name} -u${local.rds_user} -p${local.rds_pass} <mysql-main/shipping.sql
EOF
  }
}
