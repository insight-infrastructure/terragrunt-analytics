locals {
  run = yamldecode(file(find_in_parent_folders("run.yml")))
  settings = yamldecode(file(find_in_parent_folders("settings.yml")))
  secrets = yamldecode(file(find_in_parent_folders("secrets.yml")))
  versions = yamldecode(file("versions.yaml"))[local.run.environment]

  deployment_id = join(".", [ for i in local.settings.deployment_id_label_order : lookup(local.run, i)])
  deployment_vars = yamldecode(file("${find_in_parent_folders("deployments")}/${local.deployment_id}.yaml"))
  ssh_profile = local.secrets.ssh_profiles[index(local.secrets.ssh_profiles.*.name, local.deployment_vars.ssh_profile_name)]

  # Labels
  id = join("-", [ for i in local.settings.id_label_order : lookup(local.run, i)])
  name = join("", [ for i in local.settings.name_label_order : title(lookup(local.run, i))])
  tags = { for t in local.remote_state_path_label_order : t => lookup(local.run, t) }
  remote_state_path = join("/", [ for i in local.settings.remote_state_path_label_order : lookup(local.run, i)])
}