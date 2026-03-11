# AWS S3 Bucket to host a static website

- Terraform module which creates an S3 bucket configured to host a static website.

## Usage

```hcl
module "website" {
  source = "github.com/jeremycook123/s3_static_site_module"
  
  bucket_name = "bucket-1234abcd"

  create_random_suffix = true
  environment = "staging"

  tags = {
    Terraform = "true"
  }
}
```

### Generate Random bucket names

If `create_random_suffix = true`, the bucket name will include a randomly generated string to ensure the provided bucket name is unique. The default value is `false`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.70 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_bucket_policy.allow_public_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.allow_public_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [random_pet.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of S3 bucket for the website | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment bucket resides in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Github owner to use when creating webhook | `map(string)` | `{}` | no |
| <a name="input_create_random_suffix"></a> [create\_random\_suffix](#input\_github\_token) | Add random suffix to bucket name | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_arn](#output\_bucket\_id) | The id of the bucket |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The arn of the bucket |
| <a name="output_bucket_website_endpoint"></a> [bucket\_website\_endpoint](#output\_bucket\_website\_endpoint) | The website endpoint of the domain |

## License

Apache 2 Licensed. See [LICENSE](https://github.com/jeremycook123/s3_static_site_module/blob/main/LICENSE) for full details.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.30 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.36.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.ownership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.public_read_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_website_configuration.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.elevation_json](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.globe_js](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.index_html](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.js_folder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.world_jpg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_pet.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_rotate"></a> [auto\_rotate](#input\_auto\_rotate) | When true, the globe spins automatically on load. When false it is static until dragged. | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of S3 bucket for the website. | `string` | n/a | yes |
| <a name="input_create_random_suffix"></a> [create\_random\_suffix](#input\_create\_random\_suffix) | When true, appends a random pet name to the bucket name to ensure uniqueness. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment the bucket resides in (e.g. dev, staging, prod). | `string` | n/a | yes |
| <a name="input_globe_title"></a> [globe\_title](#input\_globe\_title) | Custom title displayed on the globe page. Leave null to use the default 'World Elevation' title. | `string` | `null` | no |
| <a name="input_rotation_speed"></a> [rotation\_speed](#input\_rotation\_speed) | Auto-rotation speed in radians per frame. Only meaningful when auto\_rotate = true.<br/>Increase for faster spin, decrease for slower. Typical range: 0.001 – 0.01. | `number` | `0.003` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to merge onto the S3 bucket. Pass an empty map to add none. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auto_rotate_enabled"></a> [auto\_rotate\_enabled](#output\_auto\_rotate\_enabled) | Whether auto-rotation is enabled on the globe. |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 website bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the S3 website bucket. |
| <a name="output_bucket_website_endpoint"></a> [bucket\_website\_endpoint](#output\_bucket\_website\_endpoint) | The HTTP website endpoint of the bucket. |
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | The full resolved tag map applied to the bucket. |
| <a name="output_globe_title"></a> [globe\_title](#output\_globe\_title) | The title displayed on the globe page (resolved from nullable variable). |
| <a name="output_rotation_speed"></a> [rotation\_speed](#output\_rotation\_speed) | The configured rotation speed (only meaningful when auto\_rotate = true). |
<!-- END_TF_DOCS -->