variable "log_bucket_name" {}

variable "configs_bucket_name" {}
variable "data_bucket_names" {
  type = list(string)
}
