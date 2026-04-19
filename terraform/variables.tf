variable "project_id" {
  description = "The GCP Project ID where resources will be created. You can find this in your GCP Console."
  type        = string
  default     = "calm-method-484715-e9"
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to deploy the VM in"
  type        = string
  default     = "us-central1-a"
}

variable "ssh_user" {
  description = "SSH Username for Jenkins to log in as"
  type        = string
  default     = "jenkins"
}
