variable "cidr" {
  default = "VPC Cidr block"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

variable "route53_zone_id" {
  description = "Route53 ZoneID to add external DNS records specific to the project (a user with update permissions is created)."
  default     = ""
}