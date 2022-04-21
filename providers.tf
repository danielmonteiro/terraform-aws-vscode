terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "sa-east-1"
  shared_credentials_file = "/home/daniel/.aws/creds"
  profile                 = "vscode"
}