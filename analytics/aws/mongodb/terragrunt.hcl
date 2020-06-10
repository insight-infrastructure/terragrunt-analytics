terraform {
  source = "github.com/insight-infrastructure/terraform-aws-mongodb-ec2.git?ref=${local.vars.versions.mongodb}"
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
  vpc_security_group_ids = [dependency.network.outputs.sg_public_id]
  playbook_vars_file = "./mongodb.yaml"
}
