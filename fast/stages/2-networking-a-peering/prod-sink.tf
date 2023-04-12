resource "google_logging_project_sink" "my-sink" {
  name = "prod_default-prod_audit_logs"
  project = module.prod-project.project_id
  # Can export to pubsub, cloud storage, or bigquery
  destination = "logging.googleapis.com/${var.automation.prod-log-bucket}"

  # Log all WARN or higher severity messages relating to instances
  filter = "projects/${module.prod-project.project_id}/logs/cloudaudit.googleapis.com%2Factivity OR projects/${module.prod-project.project_id}/logs/cloudaudit.googleapis.com%2Fsystem_event OR projects/${module.prod-project.project_id}/logs/cloudaudit.googleapis.com%2Fdata_access OR projects/${module.prod-project.project_id}/logs/cloudaudit.googleapis.com%2Fpolicy"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
  
}

/*resource "google_project_iam_binding" "log-writer" {
  project = var.automation.audit-log-project_id
  role = "roles/logging.bucketWriter"

  members = [
    google_logging_project_sink.my-sink.writer_identity,
  ]
}*/

resource "google_project_iam_member" "log-writer" {
  project = var.automation.audit-log-project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_project_sink.my-sink.writer_identity
}