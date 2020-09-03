terraform {
  source = "github.com/insight-infrastructure/terraform-aws-msk.git?ref=${local.vars.versions.msk}"
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
  subnet_ids = dependency.network.outputs.private_subnets

  security_group_id = dependency.network.outputs.sg_msk_id
  security_groups = module.example_no_vpc.default_security_group

  additional_security_groups = [dependency.network.outputs.sg_msk_id, dependency.network.outputs.monitoring_security_group_id]
}
