# Example: Rotating Globe

This example deploys an S3-hosted static website with a **3D globe that auto-rotates**. It demonstrates the `auto_rotate`, `rotation_speed`, and `globe_title` optional variables, as well as appending a random suffix to the bucket name to avoid naming conflicts.

## What this example creates

- An S3 bucket with website hosting enabled
- A publicly accessible 3D globe page with auto-rotation enabled
- A random suffix appended to the bucket name

## Usage

```bash
terraform init
terraform apply
```

## Key variables demonstrated

| Variable | Value | Purpose |
|----------|-------|---------|
| `create_random_suffix` | `true` | Appends a random string to avoid bucket name collisions |
| `auto_rotate` | `true` | Enables continuous globe rotation |
| `rotation_speed` | `0.002` | Controls spin speed (lower = slower) |
| `globe_title` | `"Earth in Motion"` | Overrides the default "World Elevation" page title |

## Outputs

| Output | Description |
|--------|-------------|
| `rotating_globe_url` | HTTP URL of the deployed website |
| `rotating_globe_title` | Resolved page title |
| `rotating_globe_auto_rotate` | Whether auto-rotation is enabled |
| `rotating_globe_tags` | Final tag map applied to the bucket |
