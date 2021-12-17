resource "aws_spot_instance_request" "spot" {
  count                  = var.SPOT_INSTANCE_COUNT
  ami                    = data.aws_ami.ami.id
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)
  wait_for_fulfillment   = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = local.tags["Name"]
  }
}

resource "aws_instance" "od" {
  count                  = var.OD_INSTANCE_COUNT
  ami                    = data.aws_ami.ami.id
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)
  vpc_security_group_ids = [aws_security_group.sg.id]
}

output "INSTANCE_IDS" {
  value = local.INSTANCE_IDS
}

resource "aws_ec2_tag" "ec2-name-tag" {
  count       = length(local.INSTANCE_IDS)
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "Name"
  value       = local.tags["Name"]
}


resource "aws_ec2_tag" "ec2-monitor-tag" {
  count       = length(local.INSTANCE_IDS)
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "Monitor"
  value       = "yes"
}

resource "aws_ec2_tag" "ec2-env-tag" {
  count       = length(local.INSTANCE_IDS)
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "environment"
  value       = var.ENV
}

resource "aws_ec2_tag" "ec2-component-tag" {
  count       = length(local.INSTANCE_IDS)
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "COMPONENT"
  value       = var.COMPONENT
}
