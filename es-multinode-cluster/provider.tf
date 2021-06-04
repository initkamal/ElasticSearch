# Configure the AWS Provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.42.0"
    }
  }
}

# Configure the AWS Region

provider "aws" {
  region = var.region
}
