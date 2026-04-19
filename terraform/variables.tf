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

variable "bucket_name_prefix" {
  description = "Prefix for the GCS bucket name"
  type        = string
  default     = "todo-react-app"
}
