# terragrunt-analytics

> WIP

Reference architecture to deploy various analytics components on multiple clouds. Wrapper to call 
underlying `terraform` code with `terragrunt`.  Calls `ansible` and `packer` under the hood. 

### Installing prerequisites 

```bash
# mac 
make install-deps-brew
# ubuntu 
make install-deps-ubuntu 
```

You will need AWS API keys to run this.  Please reference [this tutorial](https://www.notion.so/insightx/AWS-Keys-Tutorial-175fa12e9b5b43509235a97fca275653) 
for more information on how to get AWS API keys if you don't already have them. 

### Running components 

> Note that the CLI to configure clusters is under active development and will be added to this soon. 
> For now, only rudimentary instructions on how to configure the cluster are supplied. 

To run any component, there are two steps. 

1. Create references to secrets. 

```bash
cd analytics/aws/network 
cp secrets.yaml.example secrets.yaml
vi secrets.yaml 
# Modify the references to the appropriate values. 
```

2. Apply the AWS components 

Navigate to the directory where the components you are trying to deploy and run the following 
terragrunt commands to deploy the infrastructure. For example, to deploy a rabbitmq cluster, do the following.  

```bash
cd analytics/aws/network 
terragrunt apply 
cd ../rabbitmq
terragrunt apply 
```

### Destroying the infrastructure 

Similar to applying, `cd` into the directory that you need and run `terragrunt destroy`. 

### Customizing the Deployment 

To modify attributes of the modules, please reference the `variables.hcl` and `terragrunt.hcl` files.  The CLI under 
development will expose all of this so little effort is being made at this time to user friendly. The config files are 
admittedly a little terse right now.  Hold tight...

If you do want to modify values and you see `prod` and `dev` sections, the deployment is defaulted to `dev` 
so make modifications there per the `secrets.yaml`. 

### AWS 

- emr
- k8s-cluster
- k8s-config
- network
- rabbitmq
- rds
- redshift
- s3
- airflow-worker
- airflow-master
- dash
- superset
- spark
