variable "admin_username" {
  description = "Admin username for VMs"
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for VMs"
  sensitive   = true
}

variable "rg1_location" {
  description = "Resource Group 1 Location"
  default     = "Southeast Asia"
}

variable "rg2_location" {
  description = "Resource Group 2 Location"
  default     = "Australia East"
}

variable "ssh_pub_key_path" {
  description = "Path of SSH Public Key"
  default     = "~/.ssh/id_rsa.pub"
}
