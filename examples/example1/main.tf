terraform {
  required_version = ">=1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "website" {
  source = "github.com/jeremycook123/s3_static_site_module"

  bucket_name = "bucket-1234abcd"

  create_random_suffix = true
  environment          = "staging"

  tags = {
    Terraform = "true"
  }
}
