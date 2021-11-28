data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-mutable"
    key    = "terraform-mutable/vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "by-name" {
  name = "roboshop"
}

data "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = data.aws_secretsmanager_secret.by-name.id
}

##data "aws_ami" "ami" {
##  owners       = [973714476881]
##  name_regex   = "^Cent*"
##  most_recent  = true
##}
