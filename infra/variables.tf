variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "github_repo_owner" {
  description = "GitHub repository owner/organization"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repository name"
  type        = string
}

variable "github_connection_name" {
  description = "Name for the GitHub connection"
  type        = string
  default     = "github-connection"
}

variable "bucket_name" {
  description = "GCS bucket name for storing archives"
  type        = string
}
