provider "aws" {
  region = "${var.s3_region}"
}

terraform {
  backend "s3" {
    bucket = "amit-new-test"
    key = "test/state"
    region = "ca-central-1"
  }
}