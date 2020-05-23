output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = "${module.vpc.vpc_cidr_block}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = ["${module.vpc.private_subnets_cidr_blocks}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = ["${module.vpc.public_subnets_cidr_blocks}"]
}

output "route53_zone_id" {
  description = "Route53 Zone ID to populate with external DNS records."
  value       = "${var.route53_zone_id}"
}

output "route53_api_credentials" {
  description = "AWS API credentials to update the provided Route53 zone."
  value       = "${local.route53_api_credentials}"
}