locals {
  cluster-name = "Green"
  key-name     = "KeyS144"
}


module "vpc" {
  source = "github.com/FrazerMichael/Terraform-Modules//aws-HA-vpc"

  cluster     = local.cluster-name
  vpc-block   = "192.168.0.0/16"
  cidr-blocks = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "security-group" {
  source = "github.com/FrazerMichael/Terraform-Modules//aws-security-group"

  cluster = local.cluster-name
  vpc-id  = module.vpc.vpc-id
}

module "HA-lb" {
  source = "github.com/FrazerMichael/Terraform-Modules//aws-HA-loadbalancer"

  cluster        = local.cluster-name
  sg-id          = module.security-group.sg-id
  user-data      = file("userdata-webserver.sh")
  vpc-id         = module.vpc.vpc-id
  vpc-subnet-ids = module.vpc.subnet-ids
}