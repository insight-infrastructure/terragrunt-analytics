#!/usr/bin/env bash
set -euxo pipefail

brew install terraform terragrunt packer ansible python git
sudo pip3 install cookiecutter awscli

# Verify
ansible --version
cookiecutter --version
terragrunt -v
terraform -v
packer -v
