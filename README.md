# Terraform :

terraform scripts The ec2.tf script do following jobs :

creating a vpc

creating two subnet one is private and one is public

creating routing table and associating with the subnet

creating NAT gateway for private subnet

deploying ec2 instance in public and private subnet

# Terraform Infrastructure Deployment

This repository contains Terraform configurations to deploy a network setup in AWS, including VPC, subnets, security groups, instances, and more.

## Prerequisites

Before you begin, ensure you have the following prerequisites in place:

1. AWS Account: You must have an active AWS account.
2. AWS CLI: Install and configure the AWS Command Line Interface.
3. Terraform: Install Terraform on your local machine.

## Configuration

The `ec2.tf` file in this repository contains the main Terraform configuration. It defines resources such as VPC, subnets, security groups, instances, and more.

### Variables

The `variable.tf` file defines the variables used in the Terraform configuration. You can modify these variables to customize your deployment:

- `vpc_cidr_block`: The CIDR block for the VPC. Default: "10.0.0.0/16"
- `public_subnet_cidr_block`: The CIDR block for the public subnet. Default: "10.0.1.0/24"
- `private_subnet_cidr_block`: The CIDR block for the private subnet. Default: "10.0.2.0/24"

## Deployment

Follow these steps to deploy the infrastructure using Terraform:

1. Clone this repository to your local machine.
2. Modify the variables in the `variable.tf` file if needed.
3. Initialize Terraform by running: `terraform init`
4. Preview the changes that will be applied: `terraform plan`
5. Deploy the infrastructure: `terraform apply`

## Cleanup

To destroy the deployed infrastructure and resources, run: `terraform destroy`

## Important Notes

- Make sure you have appropriate AWS credentials configured using the AWS CLI.
- Review the Terraform configurations and variables before deploying.
- Be cautious when using sensitive information such as AWS credentials.

## Author

sreekanth pv

For any questions or issues, please contact sreekanthpv12@gmail.com  
