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

module "globe_rotating" {
  source = "jeremycook123/s3-static-website-3dglobe/aws"

  # Required variables — must always be provided
  bucket_name = "my-3dglobe"
  environment = "dev"

  # Bool flag (demo1/2 pattern) — appends a random suffix to avoid name clashes
  create_random_suffix = true

  # Bool flag — enables auto-rotation in the rendered globe.js
  # auto_rotate = true

  # Number — only meaningful when auto_rotate = true; controls spin speed
  # rotation_speed = 0.002

  # Nullable string — overrides the default "World Elevation" page title
  # globe_title = "Earth in Motion"

  # Map — merged with module base tags on the S3 bucket
  tags = {
    Owner   = "platform-team"
    Purpose = "demo3-rotating"
  }
}

# output "rotating_globe_url" {
#   description = "URL of the rotating globe website."
#   value       = "http://${module.globe_rotating.bucket_website_endpoint}"
# }

# output "rotating_globe_title" {
#   description = "Resolved title for the rotating globe (from nullable variable)."
#   value       = module.globe_rotating.globe_title
# }

# output "rotating_globe_auto_rotate" {
#   description = "Whether auto-rotation is enabled on the rotating globe."
#   value       = module.globe_rotating.auto_rotate_enabled
# }

# output "rotating_globe_tags" {
#   description = "Final tag map applied to the rotating globe bucket."
#   value       = module.globe_rotating.common_tags
# }
