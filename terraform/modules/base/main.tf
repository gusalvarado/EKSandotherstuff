data "aws_availability_zones" "available" {

}
locals {
    cluster_name = "eks-${random_string.suffix.result}" 
}
resource "random_string" "suffix" {
    length = 8
    special = false
}
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.44.0"
    name = "vpc-${var.project}-${var.environment}"
    cidr = "10.0.0.0/24"

    azs = data.aws_availability_zones.available.names
    public_subnets = ["10.0.0.0/26","10.0.0.64/26"]
    private_subnets = ["10.0.1.0/24","10.0.2.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = true

    vpc_tags = {
        "kubernetes.io/cluster/eks" = "shared"
    }
    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
        "kubernetes.io/cluster/eks" = "shared"
    }
    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = 1
        "kubernetes.io/cluster/eks" = "shared"
    }
}