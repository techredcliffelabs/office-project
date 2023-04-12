resource "google_logging_project_sink" "my-qa-sink" {
  name = "qa_default-non-prod_audit_logs"
  project = module.qa-project.project_id
  # Can export to pubsub, cloud storage, or bigquery
  destination = "logging.googleapis.com/${var.automation.qa-log-bucket}"
  # Log all WARN or higher severity messages relating to instances
  filter = "projects/${module.qa-project.project_id}/logs/cloudaudit.googleapis.com%2Factivity OR projects/${module.qa-project.project_id}/logs/cloudaudit.googleapis.com%2Fsystem_event OR projects/${module.qa-project.project_id}/logs/cloudaudit.googleapis.com%2Fdata_access"
  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
  
  
}

resource "google_logging_project_sink" "my-dev-sink" {
  name = "dev_default-non-prod_audit_logs"
  project = module.dev-project.project_id
  # Can export to pubsub, cloud storage, or bigquery
  destination = "logging.googleapis.com/${var.automation.dev-log-bucket}"

  # Log all WARN or higher severity messages relating to instances
  filter = "projects/${module.dev-project.project_id}/logs/cloudaudit.googleapis.com%2Factivity OR projects/${module.dev-project.project_id}/logs/cloudaudit.googleapis.com%2Fsystem_event OR projects/${module.dev-project.project_id}/logs/cloudaudit.googleapis.com%2Fdata_access"
  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
  
  /*depends_on = [
    google_project_iam_member.log-writer
  ]*/
}


/*resource "google_project_iam_binding" "qa-log-writer" {
  project = var.automation.audit-log-project_id
  role = "roles/logging.bucketWriter"

  members = [
    google_logging_project_sink.my-qa-sink.writer_identity,google_logging_project_sink.my-dev-sink.writer_identity,
  ]
}*/

resource "google_project_iam_member" "qa-log-writer" {
  project = var.automation.audit-log-project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_project_sink.my-qa-sink.writer_identity
}

resource "google_project_iam_member" "dev-log-writer" {
  project = var.automation.audit-log-project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_project_sink.my-dev-sink.writer_identity
}