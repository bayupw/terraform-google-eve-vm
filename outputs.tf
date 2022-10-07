output "eve_vm_public_ip" {
  description = "VM public IP."
  value       = google_compute_instance.this.network_interface[0].access_config[0].nat_ip
}

output "eve_vm_name" {
  description = "VM name."
  value       = google_compute_instance.this.name
}
