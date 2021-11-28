##resource "aws_spot_instance_request" "cheap_worker" {
##  ami                    = data.aws_ami.ami.id
##  instance_type          = "t2.micro"
##  vpc_security_group_ids = ["sg-08797573be56216ce"]
##  wait_for_fulfillment   = true
##  tags = {
##    Name = element(var.components, count.index)
##  }
##}
##
##resource "aws_ec2_tag" "tags" {
##  count       = length(var.components)
##  resource_id = element(aws_spot_instance_request.cheap_worker.*.spot_instance_id, count.index)
##  key         = "Name"
##  value       = element(var.components, count.index)
##}
