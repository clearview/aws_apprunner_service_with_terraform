terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  region     = var.region_northern_virginia
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias      = "northern_virginia_region"
}
