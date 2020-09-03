# terragrunt-analytics

> WIP - Do not use quite yet

Reference architecture to deploy various analytics components on multiple clouds. Wrapper to call underlying `terraform` code with `terragrunt`.  Calls `ansible` and `packer` under the hood.

### Deploying with CLI

```bash
# Clone this repo 
git clone https://github.com/insight-infrastructure/terragrunt-analytics 
cd terragrunt-analytics 

# Requires python3.6+.  Best to create virtualenv 
python3 -m venv env 
source env/bin/activate 

# Run the CLI to create a deployment and deploy the stack 
pip3 install nukikata 
nukikata . 
```

The CLI should walk you through configuring all the necessary components and deploying the stack.

You will need AWS API keys to run this.  Please reference [this tutorial](https://www.notion.so/insightx/AWS-Keys-Tutorial-175fa12e9b5b43509235a97fca275653) 
for more information on how to get AWS API keys if you don't already have them. 

### Manually Deploying

Navigate to the directory where the components you are trying to deploy and run the following terragrunt commands to deploy the infrastructure. For example, to deploy a rabbitmq cluster, do the following.

```bash
cd analytics/aws/network # network is a dependency for deploying anything
terragrunt apply 
cd ../rabbitmq
terragrunt apply 
```

### Destroying the infrastructure 

Similar to applying, `cd` into the directory that you need and run `terragrunt destroy`. 

### Customizing the Deployment 

> To be updated soon based on new deployment pattern

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
