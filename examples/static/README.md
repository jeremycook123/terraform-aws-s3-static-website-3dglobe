# Example: Static Globe

This example deploys an S3-hosted static website with a **3D globe that does not rotate**. It demonstrates the minimal required configuration — only `bucket_name` and `environment` are provided, allowing all optional variables to fall back to their defaults.

## What this example creates

- An S3 bucket with website hosting enabled
- A publicly accessible 3D globe page in static (non-rotating) mode

## Usage

```bash
terraform init
terraform apply
```

## Key variables demonstrated

| Variable | Default used | Resolved value |
|----------|-------------|----------------|
| `create_random_suffix` | `false` | No random suffix added to bucket name |
| `auto_rotate` | `false` | Globe is static |
| `rotation_speed` | `0.003` | Ignored because `auto_rotate = false` |
| `globe_title` | `null` | Resolves to `"World Elevation"` |
| `tags` | `{}` | Only module base tags applied |

## Outputs

| Output | Description |
|--------|-------------|
| `static_globe_url` | HTTP URL of the deployed website |
| `static_globe_title` | Resolved page title (falls back to default) |
| `static_globe_auto_rotate` | Whether auto-rotation is enabled |
