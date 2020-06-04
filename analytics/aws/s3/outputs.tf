output "log_bucket" {
  value = aws_s3_bucket.log.bucket
}

output "configs_bucket" {
  value = aws_s3_bucket.configs.bucket
}

output "data_buckets" {
  value = aws_s3_bucket.data.*.bucket
}