data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-mutable"
    key    = "terraform-mutable/db/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}
