terraform {
  source = "github.com/insight-infrastructure/terraform-aws-sagemaker.git?ref=${local.vars.versions.sagemaker}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.network]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = dependency.network.outputs.public_subnets
  additional_security_groups = [dependency.network.outputs.sg_sagemaker_id, dependency.network.outputs.monitoring_security_group_id]
}
