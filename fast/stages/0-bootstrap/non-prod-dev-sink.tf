resource "google_logging_project_sink" "my-dev-sink" {
  name = "dev_default-non-prod_audit_logs"
  project = "tcl-dev-project-1"
  # Can export to pubsub, cloud storage, or bigquery
  destination = "logging.googleapis.com/projects/tcl-prod-audit-logs-0/locations/us-central1/buckets/audit-logs_non-prod-dev"

  # Log all WARN or higher severity messages relating to instances
  filter = "projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Factivity OR projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Fsystem_event OR projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Fdata_access"
  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
  
  depends_on = [
    google_project_iam_binding.log-writer
  ]
}

resource "google_project_iam_binding" "dev-log-writer" {
  project = "tcl-prod-audit-logs-0"
  role = "roles/logging.bucketWriter"

  members = [
    google_logging_project_sink.my-dev-sink.writer_identity,
  ]

  depends_on = [
    google_project_iam_binding.log-writer
  ]
}

/*resource "google_logging_project_sink" "my-qa-sink" {
  name = "qa_default-non-prod_audit_logs"
  project = "tcl-qa-project"
  # Can export to pubsub, cloud storage, or bigquery
  destination = "logging.googleapis.com/projects/tcl-prod-audit-logs-0/locations/us-central1/buckets/audit-logs_non-prod"

  # Log all WARN or higher severity messages relating to instances
  filter = "projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Factivity OR projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Fsystem_event OR projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Fdata_access"
  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
  
}

resource "google_project_iam_binding" "qa-log-writer" {
  project = "tcl-prod-audit-logs-0"
  role = "roles/logging.bucketWriter"

  members = [
    google_logging_project_sink.my-qa-sink.writer_identity,
  ]
}*/