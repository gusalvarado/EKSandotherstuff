locals {
  external_route53_enable = "${var.route53_zone_id != "" ? true : false}"
  eks_basename            = "${module.project.namespace}-${module.project.name}-${module.project.stage}"

  route53_api_credentials = {
    aws_access_key_id     = "${element(concat(aws_iam_access_key.route53.*.id, list("")), 0)}"
    aws_secret_access_key = "${element(concat(aws_iam_access_key.route53.*.secret, list("")), 0)}"
  }
}

module "vpc_label" {
  source  = "git::https://github.com/cloudposse/terraform-null-label"
  context = "${module.project.context}"
  name    = "vpc"
}

module "route53_label" {
  source  = "git::https://github.com/cloudposse/terraform-null-label"
  context = "${module.project.context}"
  name    = "route53"

  attributes = [
    "updater",
    "${var.route53_zone_id}",
  ]

  tags = {
    Description = "Allows Route53 Zone update. Zone ID: ${var.route53_zone_id}."
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"
  cidr = "${var.cidr}"

  azs             = ["${var.azs}"]
  private_subnets = ["${var.private_subnets}"]
  public_subnets  = ["${var.public_subnets}"]

  enable_nat_gateway = true

  tags = "${module.vpc_label.tags}"

  vpc_tags = {
    "kubernetes.io/cluster/${local.eks_basename}-eks" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                          = 1
    "kubernetes.io/cluster/${local.eks_basename}-eks" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"                 = 1
    "kubernetes.io/cluster/${local.eks_basename}-eks" = "shared"
  }
}

## Create a user to manage external dns records
resource "aws_iam_user" "route53" {
  count = "${local.external_route53_enable ? 1 : 0}"
  name  = "${module.route53_label.id}"
  path  = "/${module.project.namespace}/${module.project.name}/"
  tags  = "${module.route53_label.tags}"
}

## External Route53 zone update policy
data "aws_iam_policy_document" "route53" {
  count = "${local.external_route53_enable ? 1 : 0}"

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${var.route53_zone_id}",
    ]
  }

  statement {
    actions = [
      "route53:GetChange",
    ]

    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZones",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "route53" {
  count       = "${local.external_route53_enable ? 1 : 0}"
  name        = "${module.route53_label.id}"
  description = "Allows Route53 Zone update. Zone ID: ${var.route53_zone_id}."
  policy      = "${data.aws_iam_policy_document.route53.json}"
}

resource "aws_iam_user_policy_attachment" "route53" {
  user       = "${aws_iam_user.route53.name}"
  policy_arn = "${aws_iam_policy.route53.arn}"
}

resource "aws_iam_access_key" "route53" {
  count = "${local.external_route53_enable ? 1 : 0}"
  user  = "${aws_iam_user.route53.name}"
}

## Not required since at least traefik does not perform role assume.
#

# data "aws_iam_policy_document" "assume_route53" {
#   count = "${local.external_route53_enable ? 1 : 0}"

#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "AWS"
#       identifiers = ["${aws_iam_user.route53.arn}"]
#     }
#   }
# }


# resource "aws_iam_role" "assume_route53" {
#   count              = "${local.external_route53_enable ? 1 : 0}"
#   name               = "${module.route53_label.id}"
#   assume_role_policy = "${data.aws_iam_policy_document.assume_route53.json}"
#   tags               = "${module.route53_label.tags}"
# }