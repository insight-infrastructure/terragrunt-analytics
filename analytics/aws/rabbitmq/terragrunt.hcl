terraform {
  source = "github.com/ulamlabs/terraform-aws-rabbitmq.git?ref=${local.vars.versions.rabbitmq}"
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

  ssh_key_name                      = dependency.network.outputs.key_names[0]
  elb_additional_security_group_ids = [dependency.network.outputs.sg_public_id]
  min_size                          = "3"
  max_size                          = "3"
  desired_size                      = "3"
}
