output "bucket_name" {
  description = "Name of the GCS bucket"
  value       = google_storage_bucket.source_archives.name
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository details"
  value = {
    name     = google_artifact_registry_repository.main.name
    location = google_artifact_registry_repository.main.location
    url      = "https://${google_artifact_registry_repository.main.location}-generic.pkg.dev/${var.project_id}/${google_artifact_registry_repository.main.repository_id}"
  }
}

output "service_account_email" {
  description = "Service account email"
  value       = google_service_account.cloudbuild_sa.email
}

output "cloud_build_trigger_id" {
  description = "Cloud Build trigger ID"
  value       = google_cloudbuild_trigger.main_branch_archive.trigger_id
}
