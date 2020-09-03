variable "log_bucket_name" {
  default = ""
}

variable "configs_bucket_name" {
  default = ""
}

variable "data_bucket_names" {
  default = []
  type = list(string)
}
