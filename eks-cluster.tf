module "eks" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  subnets = module.vpc.private_subnets

  tags = {
    Environment = var.environment
    Name = local.cluster_name
  }
  vpc_id = module.vpc.vpc_id

  worker_groups = [
      {
        name = "worker-group-1"
        instance_type = "t2.micro"
        additional_userdata = "group1"
        asg_desired_capacity = 2
        additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      },
      {
        name = "worker-group-2"
        instance_type = "t2.micro"
        additional_userdata = "group2"
        asg_desired_capacity = 2
        additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      }
  ]
}

data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}