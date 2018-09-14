## --------------------------------
## Locals variable
## --------------------------------

locals {
  azs = "${format("%s%s", var.region, var.azs[0])},${format("%s%s", var.region, var.azs[1])},${format("%s%s", var.region, var.azs[2])}"
  public_subnets = "${var.cidr}${lookup(var.SubnetConfig, "SubnetPublicNet1")},${var.cidr}${lookup(var.SubnetConfig, "SubnetPublicNet2")},${var.cidr}${lookup(var.SubnetConfig, "SubnetPublicNet3")}"
  private_subnets = "${var.cidr}${lookup(var.SubnetConfig, "SubnetWorkerNet1")},${var.cidr}${lookup(var.SubnetConfig, "SubnetWorkerNet2")},${var.cidr}${lookup(var.SubnetConfig, "SubnetWorkerNet3")}"
}


## --------------------------------
## VPC
## --------------------------------

module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  version                      = "1.26.0"
  name                         = "${var.name}"
  cidr                         = "${format("%s%s", var.cidr, lookup(var.SubnetConfig, "NetworkVPC"))}"
  azs                          = "${split(",", local.azs )}"
  public_subnets               = "${split(",", local.public_subnets )}"
  private_subnets              = "${split(",", local.private_subnets )}"
  enable_dns_support           = true
  enable_dns_hostnames         = true
  enable_nat_gateway           = true
  enable_vpn_gateway           = false
  enable_s3_endpoint           = true

  tags = {
    Name            = "${var.name}"
    EnvironmentName = "${var.environment}"
    Owner           = "${var.owner}"
  }
}

