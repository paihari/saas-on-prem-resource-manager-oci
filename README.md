# terraform-oci-fullstack-windmill

Windmill is an open-source low code builder to build all tools (endpoints, workflows, UIs) through the combination of code (in Typescript, Python, Go, Bash, SQL or any docker image) . It embeds all-in-one:

1) an execution runtime to execute functions on a fleet of workers
2) an orchestrator to compose functions into powerful flows 
3) an app builder to build application and data-intensive dashboards built with low-code or JS frameworks such a React.

More details

https://www.windmill.dev/docs/intro

This repository contains the artifacts to self host windmill application on Oracle Cloud Infrastructure.

It encompasses PostgreSQL cluster on Oracle Cloud Infrastructure Compute instances. In this architecture, the servers are configured in master and standby configuration and use streaming replication.

For details of the Application architecture, see [_Windmill Architecture_](https://docs.oracle.com/en/solutions/deploy-postgresql-db/index.html)

For details of the DB architecture, see [_PostgreSQL database_](https://docs.oracle.com/en/solutions/deploy-postgresql-db/index.html)

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-lists`, `subnets`, `container instances`, `Bastion`, and `instances`.

- Quota to create the following resources: 1 VCN, 2 subnet, 1 Internet Gateway, 1 NAT,  2 route rules, and 3 compute instances (1 primary master PostgreSQL instance and 2 Standby instances of PostgreSQL) and 5 container instances

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## Deploy Using Automation Framework
The deployment of the Windmill application is completely automated with One Click option in GitHub, the automation is possible under the hood using

- GitHub Release
- GitHub Action
- Hosted Windmill Services
- OCI Resource Manager Private Template
- OCI Resource Manager Stacks Plan
- OCI Resource Manager Stacks Apply

# Super Click

1. Got to [Releases]: https://github.com/paihari/terraform-oci-fullstack-windmill/releases/new
2. Choose a incremental Tag, with Target: main
3. Give a Title and Describle the release, Use Generate Release notes as compliment
4. Leave the default options
5. Click Publish Release
6. Done

**How to Trace**
1. ![Git Hub Release](https://github.com/paihari/terraform-oci-fullstack-windmill/blob/module_branch/images/Snip20231023_3.png)
2. ![OCI Private Template ](https://github.com/paihari/terraform-oci-fullstack-windmill/blob/module_branch/images/Snip20231023_3.png)
3. ![OCI Stack ](https://github.com/paihari/terraform-oci-fullstack-windmill/blob/module_branch/images/Snip20231023_3.png)
4. ![Job Plan ](https://github.com/paihari/terraform-oci-fullstack-windmill/blob/module_branch/images/Snip20231023_3.png)
5. ![Job Apply ](https://github.com/paihari/terraform-oci-fullstack-windmill/blob/module_branch/images/Snip20231023_3.png)



## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/paihari/terraform-oci-fullstack-windmill/releases/latest/download/terraform-oci-fullstack-windmill.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

**OR**

Download the latest [`terraform-oci-fullstack-windmill.zip`](../../releases/latest/download/terraform-oci-fullstack-windmill.zip) file. [Login](https://cloud.oracle.com/resourcemanager/stacks/create) to Oracle Cloud Infrastructure to import the stack
    > `Home > Developer Services > Resource Manager > Stacks > Create Stack`
Upload the `terraform-oci-fullstack-windmill.zip` file that was downloaded earlier,    

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

8. To destroy, Navigate to **Resource Manager >> Stacks >> Stack details** and click **Destroy**


## Deploy Using the Terraform CLI

### Clone the Repository
Now, you'll want a local copy of this repo. You can make that with the commands:

    git clone https://github.com/paihari/terraform-oci-fullstack-windmill.git
    cd terraform-oci-fullstack-windmill
    ls

### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Secondly, create a `terraform.tfvars` file and populate with the following information:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# availability Domain 
availability_domain= "<availability_domain>" # for example vWQc:EU-FRANKFURT-1-AD-1

# Compartment
compartment_ocid        = "<compartment_ocid>"

# PostgreSQL Password
postgresql_password     = "<postgresql_password>"

````

### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply

### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy

## Test the Stack
Find the Public IP Address of the WindmillServer  by Navigating to **Developer Services >> Container Instances** 
Navigate in the browser
```
http://PUBLIC-IP-ADDRESS-OF-WINDMILLSERVER:8000

```

Login using crdentials

```
admin@windmill.dev/changeme

```






