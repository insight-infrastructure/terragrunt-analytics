terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-rds.git?ref=v2.15.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

inputs = {
  identifier = local.vars.id
  name = "${local.vars.name}-rds"

  subnet_ids = data.aws_subnet_ids.all.ids
  vpc_security_group_ids = [data.aws_security_group.default.id]

  allocated_storage = 5

  engine            = "postgres"
  engine_version    = "9.6.9"
  instance_class    = "db.t2.large"
  family = "postgres9.6"
  major_engine_version = "9.6"

  allocated_storage = 5
  storage_encrypted = false

  final_snapshot_identifier = "demodb"
  username = local.vars.secrets.rds_admin_user
  password = local.vars.secrets.rds_admin_password
  port     = "5432"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  backup_retention_period = 0

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  deletion_protection = false
}


