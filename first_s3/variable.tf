variable "environment" {
  default = "test"
  description = "Env Name"
  type = "string"
}
variable "s3_bucket_name" {
  default     = "amit-main-test"
  description = "Name of the S3 bucket"
  type        = "string"
}

variable "s3_region" {
  type    = "list"
  default = ["ca-central-1"]
}

locals {
  s3_tags = {
    created_by  = "terraform"
    environment = "${var.environment}"
  }
}
