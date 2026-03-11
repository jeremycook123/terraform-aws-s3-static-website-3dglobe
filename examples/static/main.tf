terraform {
  required_version = ">=1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "globe_static" {
  source  = "jeremycook123/s3-static-website-3dglobe/aws"
  version = "0.0.9"

  # Required variables
  bucket_name = "my-3dglobe-static"
  environment = "dev"

  # create_random_suffix → defaults to false  (no random suffix added)
  # auto_rotate          → defaults to false  (globe is static)
  # rotation_speed       → defaults to 0.003  (ignored because auto_rotate=false)
  # globe_title          → defaults to null   → resolves to "World Elevation"
  # tags                 → defaults to {}     (only base tags applied)
}

output "static_globe_url" {
  description = "URL of the static globe website."
  value       = "http://${module.globe_static.bucket_website_endpoint}"
}

output "static_globe_title" {
  description = "Resolved title for the static globe (falls back to default)."
  value       = module.globe_static.globe_title
}

output "static_globe_auto_rotate" {
  description = "Whether auto-rotation is enabled on the static globe."
  value       = module.globe_static.auto_rotate_enabled
}
