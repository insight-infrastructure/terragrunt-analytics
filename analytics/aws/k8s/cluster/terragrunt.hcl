terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks.git"
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
  security_group_id = dependency.network.outputs.k8s_security_group_id
  cluster_autoscale = true
  cluster_autoscale_max_workers = 10
  cluster_autoscale_min_workers = 3
  num_workers = 3
  worker_instance_type = "m5.large"
  worker_additional_security_group_ids = [dependency.network.outputs.consul_security_group_id, dependency.network.outputs.monitoring_security_group_id]
}
