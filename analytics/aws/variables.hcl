locals {
  ######################
  # Deployment Variables
  ######################
  namespace = "insight"
  stack = "analytics"
  provider = "aws"
  environment = "dev"
  region = "us-east-1"

  remote_state_region = "us-east-1"
  vault_enabled = true
  consul_enabled = true
  monitoring_enabled = true
  prometheus_enabled = true
  create_public_regional_subdomain = true
  use_lb = true

  num_azs = 3

  ###################
  # Environment Logic
  ###################
  env_vars = {
    dev = {
      airflow_instance_type = "t2.small"
    }
    prod = {
      airflow_instance_type = "c5.large"
    }
  }[local.environment]

  # Imports
  versions = yamldecode(file("${get_parent_terragrunt_dir()}/versions.yaml"))[local.environment]
  secrets = yamldecode(file("${get_parent_terragrunt_dir()}/secrets.yaml"))[local.environment]

  ###################
  # Label Boilerplate
  ###################
  label_map = {
    namespace = local.namespace
    stack = local.stack
    provider = local.provider
    environment = local.environment
    region = local.region
  }

  remote_state_path_label_order = ["namespace", "stack", "provider", "environment", "region"]
  remote_state_path = join("/", [ for i in local.remote_state_path_label_order : lookup(local.label_map, i)])

  id_label_order = ["namespace", "stack", "environment"]
  id = join("-", [ for i in local.id_label_order : lookup(local.label_map, i)])

  name_label_order = ["stack", "environment"]
  name = join("", [ for i in local.name_label_order : title(lookup(local.label_map, i))])

  tags = { for t in local.remote_state_path_label_order : t => lookup(local.label_map, t) }
}
