terraform {
  source = "github.com/PowerDataHub/terraform-aws-airflow.git?ref=${local.vars.versions.airflow-cluster}"
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
  security_group_id = dependency.network.outputs.vault_security_group_id

  key_name                 = dependency.network.outputs.key_name
  cluster_name             = "airflow-${local.vars.name}"
  cluster_stage            = local.vars.environment
  db_password              = local.vars.rds_admin_password

//  fernet_key               = "your-fernet-key" # see https://airflow.readthedocs.io/en/stable/howto/secure-connections.html
  # OPTIONALS
//  custom_requirements      = "path/to/custom/requirements.txt" # See examples/custom_requirements for more details
//  custom_env               = "path/to/custom/env"              # See examples/custom_env for more details

  ingress_cidr_blocks      = ["0.0.0.0/0"]                     # List of IPv4 CIDR ranges to use on all ingress rules
  ingress_with_cidr_blocks = [                                 # List of computed ingress rules to create where 'cidr_blocks' is used
    {
      description = "List of computed ingress rules for Airflow webserver"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "List of computed ingress rules for Airflow flower"
      from_port   = 5555
      to_port     = 5555
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  load_example_dags        = false
  load_default_conns       = false
}
