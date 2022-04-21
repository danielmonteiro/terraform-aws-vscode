# Terraform + AWS + VSCode
Provision an EC2 instance in AWS, allowing remote access.
Based on https://www.youtube.com/watch?v=iRaai1IBlB0

## Steps
- Create an IAM user with Access Key access
- Update ./aws/credentials adding the new profile with access key and secret
- `ssh-keygen -t ed25519` to create key/pair
- `ssh -i ~/.ssh/vscode_terraform ubuntu@<public_ip>` to ssh into remote EC2 instance

## Docs
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Commands
- `terraform init` - initializes terraform and creates the `.terraform.lock` file
- `terraform plan` - will display wich changes will be applied (added, changed, destroyed)
- `terraform apply` - adds, changes or destroy resources 
  - can be used with `-auto-approve`
  - can be used with `-replace aws_instance.vscode_terraform_instance` (forces the execution when there's no change in State)
  - can be used with `-refresh-only` updates the State
  - can be used with `-var="host_os=windows"` to specify variable values
  - can be used with `-var-file="linux-tfvars"` to use a file with variable values
- `terraform state list` - lists the resources that were created
- `terraform state show <resource_name>` - shows resource details (`<resource_name>` could be `aws_vpc.vscode_terraform_vpc`)
- `terraform show` - shows the entire state
- `terraform plan -destroy` - lists what would be destroyed
- `terraform destroy` - destroy all resources created by terraform (can be used with `-auto-approve`)
- `terraform fmt` - fixes all the inconsistencies in format
- `terraform console` - opens up a console where you can, for example, check variable values (like `var.host_os`)
- `terraform output` - prints the **outputs**