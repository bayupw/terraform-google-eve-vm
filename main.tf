# Generate random string
resource "random_string" "this" {
  count = var.random_suffix ? 1 : 0

  length  = var.random_string_length
  numeric = true
  special = false
  upper   = false
}

# Create VPC
resource "google_compute_network" "this" {
  count = var.create_vpc ? 1 : 0

  project                 = var.project_id
  name                    = var.random_suffix ? "${lower(var.network_name)}-${random_string.this[0].id}" : lower(var.network_name)
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

# Create subnet
resource "google_compute_subnetwork" "this" {
  count = var.create_vpc ? 1 : 0

  project       = var.project_id
  name          = var.random_suffix ? "${lower(var.subnet_name)}-${random_string.this[0].id}" : lower(var.subnet_name)
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.this[0].id
}

# Retrieve my public IP
data "http" "myip" {
  url = "http://ifconfig.me"
}

# Create firewall from my public IP
resource "google_compute_firewall" "default" {
  count = var.create_vpc ? 1 : 0

  project = var.project_id
  name    = "${google_compute_network.this[0].name}-firewall"
  network = google_compute_network.this[0].name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [80, 443, 22]
  }

  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
}

# Create firewall for IAP https://cloud.google.com/iap/docs/tcp-by-host
resource "google_compute_firewall" "iap" {
  count = var.create_vpc ? 1 : 0

  project = var.project_id
  name    = "${google_compute_network.this[0].name}-iap"
  network = google_compute_network.this[0].name

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = local.iap_range
}


# External static ip
resource "google_compute_address" "this" {
  name         = "${var.vm_name}-external"
  address_type = "EXTERNAL"
  region       = var.region
}

# Create GCP VM image
resource "google_compute_instance" "this" {
  project      = var.project_id
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = "${var.region}-${var.zone}"

  boot_disk {
    initialize_params {
      image = var.boot_disk
      size  = var.disk_size
    }
  }

  network_interface {
    network    = local.network
    subnetwork = local.subnetwork

    access_config {
      nat_ip = google_compute_address.this.address
    }
  }

  metadata = {
    serial-port-enable = true
  }

  advanced_machine_features {
    enable_nested_virtualization = true
  }

  can_ip_forward = true
}

locals {
  iap_range  = ["35.235.240.0/20"] # https://cloud.google.com/iap/docs/tcp-by-host
  network    = var.create_vpc ? google_compute_network.this[0].name : var.network_name
  subnetwork = var.create_vpc ? google_compute_subnetwork.this[0].name : var.subnet_name
}