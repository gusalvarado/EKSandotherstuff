provider "aws" {
  region = var.region
  version = ">= 2.28.1"
}
module "vpc" {
    source = "./modules/networking"
}