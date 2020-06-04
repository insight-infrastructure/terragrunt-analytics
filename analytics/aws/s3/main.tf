

data "aws_caller_identity" "this" {}

resource "aws_s3_bucket" "log" {
  bucket = var.log_bucket_name == "" ? "logs-${data.aws_caller_identity.this.account_id}" : var.log_bucket_name
}

resource "aws_s3_bucket" "configs" {
  bucket = var.configs_bucket_name == "" ? "configs-${data.aws_caller_identity.this.account_id}" : var.configs_bucket_name
}

resource "aws_s3_bucket" "data" {
  count = length(var.data_bucket_names)
}
