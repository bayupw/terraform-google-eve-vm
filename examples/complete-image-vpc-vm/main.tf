module "eve-gcp-image" {
  source = "bayupw/terraform-google-eve-gcp-image/google"
  version = "1.0.0"

  project_id  = "bwibowo-01"
  region      = "australia-southeast1"
  eve_version = "8.11.0"
}

output "eve-gcp-image" {
  value = module.eve-gcp-image
}

module "eve-vm" {
  source = "bayupw/google/terraform-google-eve-vm/google"
  version = "1.0.0"

  project_id = "my-project-id"
  region     = "australia-southeast1"
  boot_disk  = module.eve-gcp-image.compute_image_id

  depends_on = [module.eve-gcp-image]
}

output "eve-vm" {
  value = module.eve-vm
}
