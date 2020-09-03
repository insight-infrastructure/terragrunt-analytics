terraform {
  source = "github.com/cloudposse/terraform-aws-emr-cluster.git?ref=${local.vars.versions.network}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals

  common = {
    ebs_root_volume_size = 10
    visible_to_all_users = true
    release_label = "emr-5.25.0"
//    applications = ["Hive", "Presto", "Spark"]
    create_task_instance_group = false
  }

  dev = {
    core_instance_group_instance_type = "m4.large"
    core_instance_group_instance_count = 1
    core_instance_group_ebs_size = 10
    core_instance_group_ebs_type = "gp2"
    core_instance_group_ebs_volumes_per_instance = 1

    master_instance_group_instance_type = "m4.large"
    master_instance_group_instance_count = 1
    master_instance_group_ebs_size = 10
    master_instance_group_ebs_type = "gp2"
    master_instance_group_ebs_volumes_per_instance = 1
  }

  prod = {
    core_instance_group_instance_type = "m4.large"
    core_instance_group_instance_count = 1
    core_instance_group_ebs_size = 10
    core_instance_group_ebs_volumes_per_instance = 1

    master_instance_group_instance_type = "m4.large"
    master_instance_group_instance_count = 1
    master_instance_group_ebs_size = 10
    master_instance_group_ebs_type = "gp2"
    master_instance_group_ebs_volumes_per_instance = 1
  }

  network = find_in_parent_folders("network")
  s3 = find_in_parent_folders("s3")
}

dependencies {
  paths = [local.network, local.s3]
}

dependency "network" {
  config_path = local.network
}

dependency "s3" {
  config_path = local.s3
}

inputs = merge({
  name = "emr-cluster"
  vpc_id = dependency.network.outputs.vpc_id
  subnet_id = dependency.network.outputs.private_subnets[0]
  route_table_id = dependency.network.outputs.private_route_table_ids[0]
  subnet_type = "private"

  core_instance_group_ebs_type = "gp2"
  master_instance_group_ebs_type = "gp2"

  vpc_name = dependency.network.outputs.vpc_id
  subnet_ids = dependency.network.outputs.public_subnets
  security_group_id = dependency.network.outputs.sg_public_id

  master_allowed_security_groups = [dependency.network.outputs.sg_public_id, dependency.network.outputs.sg_bastion_id]
  slave_allowed_security_groups = [dependency.network.outputs.sg_public_id, dependency.network.outputs.sg_bastion_id]

  key_name = dependency.network.outputs.key_names[0]

  log_uri = format("s3n://%s/", dependency.s3.outputs.log_bucket)
}, local[local.vars.environment], local.common)
