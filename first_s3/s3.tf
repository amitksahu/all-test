resource "aws_s3_bucket" "main" {
  bucket = "${var.s3_bucket_name}-${var.environment}"
  acl    = "private"

  tags = "${local.s3_tags}"
  region = "${var.s3_region}"
}
