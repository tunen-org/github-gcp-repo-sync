terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "cloudbuild_api" {
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "artifactregistry_api" {
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "storage_api" {
  service = "storage-component.googleapis.com"
}

# Create GCS bucket for source archives
resource "google_storage_bucket" "source_archives" {
  name     = var.bucket_name
  location = var.region

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.storage_api]
}

# Service account for Cloud Build
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cloudbuild-archive-sa"
  display_name = "Cloud Build Archive Service Account"
}

# IAM bindings for the service account
resource "google_storage_bucket_iam_member" "cloudbuild_storage_admin" {
  bucket = google_storage_bucket.source_archives.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_project_iam_member" "cloudbuild_logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# GitHub connection (you'll need to authenticate this manually)
resource "google_cloudbuild_trigger" "main_branch_archive" {
  name        = "main-branch-archive-trigger"
  description = "Archive main branch on push"

  github {
    owner = var.github_repo_owner
    name  = var.github_repo_name
    push {
      branch = "^main$"
    }
  }

  service_account = google_service_account.cloudbuild_sa.id
  filename        = "cloudbuild.yaml"

  depends_on = [google_project_service.cloudbuild_api]
}
