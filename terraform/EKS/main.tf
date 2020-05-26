locals {
  cluster_name = "${var.cluster_name != "" ? var.cluster_name : module.eks-label.id}"

  asg_defaults = {
    asg_desired_capacity = 3
    asg_max_size         = 5
    asg_min_size         = 3
    instance_type        = "t3.small"
    subnets              = "${join(",", var.subnets)}"
  }

  main_asg  = "${merge(local.asg_defaults, var.main_asg, map("name", "main"))}"
  other_asg = "${merge(local.asg_defaults, var.other_asg, map("name", "spark"))}"
}

module "eks-label" {
  source  = "git::https://github.com/cloudposse/terraform-null-label"
  context = "${module.project.context}"
  name    = "eks"
}

module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "2.1.0"
  cluster_name       = "${local.cluster_name}"
  subnets            = ["${var.subnets}"]
  vpc_id             = "${var.vpc_id}"
  worker_groups      = ["${local.main_asg}", "${local.other_asg}"]
  worker_group_count = "2"
}