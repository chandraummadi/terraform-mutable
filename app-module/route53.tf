resource "aws_route53_record" "record" {
  count   = var.IS_PRIVATE_LB ? 1 : 0
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "${var.COMPONENT}-${var.ENV}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.terraform_remote_state.alb.outputs.PRIVATE_ALB_DNS]
}
