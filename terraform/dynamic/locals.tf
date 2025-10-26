locals {
  instance_type = "t3.micro"
  common_name = "${var.common-tags.project}-${var.common-tags.environment}"
  ec2_tags =merge(
    var.common-tags,
    {
      Name = "${local.common_name}-local-demo"
    }
  )
}
