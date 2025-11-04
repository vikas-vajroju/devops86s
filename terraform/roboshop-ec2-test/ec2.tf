module "catalogue" {
    source = "../terraform-aws-instance"
    ami-id = var.ami-id
    sg_ids = var.sg_ids
    instance_type = var.instance_type
}