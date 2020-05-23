variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  default     = "1.11"
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = "list"
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
}

variable "main_asg" {
  description = "Main ActionML scalability group settings, the group for DBs and APIs."

  default = {
    # asg_desired_capacity = 3  # asg_max_size = 5  # asg_min_size = 3  # instance_type = "t3.small"  # subnets = "${join(",", var.subnets)}"
  }
}

variable "spark_asg" {
  description = "Spark ActionML scalability group settings, the group for Spark cluster."

  default = {
    # asg_desired_capacity = 3  # asg_max_size = 5  # asg_min_size = 3  # instance_type = "t3.small"  # subnets = "${join(",", var.subnets)}"
  }
}