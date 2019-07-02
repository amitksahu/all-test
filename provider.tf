provider "aws" {
  region = "${var.region}"
  version = "2.16"
}

terraform {
  backend "s3" {
    bucket = "amit-new-test"
    key = "test/vpc"
    region = "ca-central-1"
  }
}
