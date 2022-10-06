module "eve-vm" {
  source = "bayupw/eve-vm/google"
  version = "1.0.0"

  project_id = "my-project-id"
  region     = "australia-southeast1"
  boot_disk  = "eve-image"

  depends_on = [module.eve-gcp-image]
}

output "eve-vm" {
  value = module.eve-vm
}
