## --------------------------------
## Variables - VPC
## --------------------------------


variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "azs" {
  type = "list"
  description = "Glovo Stack Availability zone list"
  default = ["a", "b", "c"]
}

variable "cidr" {
  description = "Glovo Stack cidr"
  default = "10.51"
}

variable "SubnetConfig" {
  type = "map"
  description = "Subnet Config (CIDR)"
  default = {
    NetworkVPC =  ".0.0/16"
    SubnetPublicNet1 = ".11.0/24"
    SubnetPublicNet2 = ".12.0/24"
    SubnetPublicNet3 = ".13.0/24"
    SubnetPublicNet4 = ".14.0/24"
    SubnetWorkerNet1 = ".31.0/24"
    SubnetWorkerNet2 = ".32.0/24"
    SubnetWorkerNet3 = ".33.0/24"
    SubnetWorkerNet4 = ".34.0/24"
  }
}

variable "aws_key_name" {
  description = "AWS SSH key"
  default = "vimruls_key2"
}

variable "name" {
  description = "Stack"
  default = "Glovo-Stack"
}

variable "environment" {
  description = "Environment"
  default = "dev"
}

variable "owner" {
  description = "DevOps Owner"
  default = "devops"
}

## --------------------------------
## Variables - AppInstance
## --------------------------------

variable "instance_ami" {
  description = "App instance AMI"
  default = "ami-035925861276f71c8"
} 


variable "instance_type" {
  description = "WebServer Instance Type"
  default = "t2.micro"
}

variable "min_cluster_size" {
  description = "MinSize"
  default = "1"
}

variable "max_cluster_size" {
  description = "maxsize"
  default = "3"
}

variable "des_cluster_size" {
  description = "DesiredSize"
  default = "1"
}

variable "secret_header_value" {
  description = "HeaderValue"
  default = 0
}
