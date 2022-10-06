# Terraform EVE-OS Image for GCP

Terraform module to create EVE-OS VM on GCP VM with nested virtualization enabled

Set environment variables

```bash
export GOOGLE_APPLICATION_CREDENTIALS=gcp-key.json
export GOOGLE_PROJECT="my-project-id"
export GOOGLE_ZONE="australia-southeast1"
```

## Usage with terraform-google-eve-gcp-image module to create image and upload to storage bucket

```hcl
module "eve-gcp-image" {
  source = "bayupw/eve-gcp-image/google"
  version = "1.0.0"

  project_id  = "my-project-id"
  region      = "australia-southeast1"
  eve_version = "8.11.0"
}

output "eve-gcp-image" {
  value = module.eve-gcp-image
}

module "eve-vm" {
  source = "bayupw/google/eve-vm/google"
  version = "1.0.0"

  project_id = "my-project-id"
  region     = "australia-southeast1"
  boot_disk  = module.eve-gcp-image.compute_image_id

  depends_on = [module.eve-gcp-image]
}

output "eve-vm" {
  value = module.eve-vm
}
```

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/bayupw/terraform-google-eve-vm/issues/new) section.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/bayupw/terraform-google-eve-vm/tree/master/LICENSE) for full details.