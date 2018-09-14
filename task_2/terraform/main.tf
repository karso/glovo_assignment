## --------------------------------
## Provider - AWS
## --------------------------------

provider "aws" {
  region = "${var.region}"
  version = "1.13.0"
}

provider "template" {
  version = "1.0.0"
}

provider "null" {
  version = "1.0.0"
}
