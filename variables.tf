# ── Required variables ────────────────────────────────────────────────────────

variable "bucket_name" {
  description = "Name of S3 bucket for the website."
  type        = string
}

variable "environment" {
  description = "Environment the bucket resides in (e.g. dev, staging, prod)."
  type        = string
}

# ── Optional variables — map(string) ─────────────────────────────────────────

variable "tags" {
  description = "Additional tags to merge onto the S3 bucket. Pass an empty map to add none."
  type        = map(string)
  default     = {}
}

# ── Optional variables — bool feature flags ───────────────────────────────────

variable "create_random_suffix" {
  description = "When true, appends a random pet name to the bucket name to ensure uniqueness."
  type        = bool
  default     = false
}

variable "auto_rotate" {
  description = "When true, the globe spins automatically on load. When false it is static until dragged."
  type        = bool
  default     = false
}

# ── Optional variables — number ───────────────────────────────────────────────

variable "rotation_speed" {
  description = <<-EOT
    Auto-rotation speed in radians per frame. Only meaningful when auto_rotate = true.
    Increase for faster spin, decrease for slower. Typical range: 0.001 – 0.01.
  EOT
  type        = number
  default     = 0.003
}

# ── Optional variables — nullable string ──────────────────────────────────────
# default = null signals "not provided". The module falls back to a built-in
# default title when the caller omits this variable (nullable pattern).

variable "globe_title" {
  description = "Custom title displayed on the globe page. Leave null to use the default 'World Elevation' title."
  type        = string
  default     = null
}
