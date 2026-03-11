output "bucket_id" {
  description = "The ID of the S3 website bucket."
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "The ARN of the S3 website bucket."
  value       = aws_s3_bucket.website.arn
}

output "bucket_website_endpoint" {
  description = "The HTTP website endpoint of the bucket."
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

# ── Outputs derived from new variables ───────────────────────────────────────

output "globe_title" {
  description = "The title displayed on the globe page (resolved from nullable variable)."
  value       = local.resolved_title
}

output "auto_rotate_enabled" {
  description = "Whether auto-rotation is enabled on the globe."
  value       = var.auto_rotate
}

output "rotation_speed" {
  description = "The configured rotation speed (only meaningful when auto_rotate = true)."
  value       = var.rotation_speed
}

output "common_tags" {
  description = "The full resolved tag map applied to the bucket."
  value       = local.common_tags
}
