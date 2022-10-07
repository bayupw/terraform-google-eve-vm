variable "random_suffix" {
  description = "Set to true to append random suffix."
  type        = bool
  default     = true
}

# Length of random string to be appended to the name
variable "random_string_length" {
  description = "Random string length."
  type        = number
  default     = 4
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "create_vpc" {
  description = "Set to true to create vpc."
  type        = bool
  default     = true
}

variable "subnet_cidr" {
  description = "Subnet CIDR."
  type        = string
  default     = "10.2.0.0/24"
}

variable "network_name" {
  description = "Existing or new VPC name."
  type        = string
  default     = "eve-vpc"
}

variable "subnet_name" {
  description = "Existing or new subnet name."
  type        = string
  default     = "eve-subnet"
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "australia-southeast1"
}

variable "routing_mode" {
  description = "Routing mode."
  type        = string
  default     = "REGIONAL"
}

variable "zone" {
  description = "GCP zone."
  type        = string
  default     = "a"
}

variable "boot_disk" {
  description = "Existing boot disk name or path."
  type        = string
  default     = null
}

variable "machine_type" {
  description = "GCP VM type."
  type        = string
  default     = "n2-standard-4"
}

variable "vm_name" {
  description = "GCP VM name."
  type        = string
  default     = "eve-vm1"
}
