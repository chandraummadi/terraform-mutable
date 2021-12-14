resource "aws_spot_instance_request" "mongodb" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t2.micro"
  spot_type = "persistent"
  instance_interruption_behavior = "stop"
  vpc_security_group_ids = [aws_security_group.mongodb-sg.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS[0]
  wait_for_fulfillment   = true
  tags = {
    Name = "mongodb-${var.ENV}"
  }
}

resource "aws_ec2_tag" "mongodb" {
  resource_id = aws_spot_instance_request.mongodb.spot_instance_id
  key         = "Name"
  value       = "mongodb-${var.ENV}"
}


resource "aws_security_group" "mongodb-sg" {
  name        = "mongodb-${var.ENV}"
  description = "mongodb-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
  {
    description      = "mongodb"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = local.ALL_CIDR
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = local.ALL_CIDR
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
]

  egress = [
    {
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
    Name = "mongodb-${var.ENV}"
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "mongodb-${var.ENV}.roboshop.internal"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.mongodb.private_ip]
  allow_overwrite = true
}

resource "null_resource" "mongodb" {
  depends_on = [aws_route53_record.mongodb]
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.mongodb.private_ip
      user     = local.ssh_user
      password = local.ssh_pass
    }
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible",
      "ansible-pull -U https://github.com/chandraummadi/Devops-projects.git Ansible/roboshop/roboshop-pull.yml -e COMPONENT=mongodb -e ENV=dev"
    ]
  }
}
