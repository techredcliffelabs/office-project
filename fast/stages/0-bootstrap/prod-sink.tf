resource "google_logging_project_sink" "my-sink" {
  name = "prod_default-prod_audit_logs"
  project = "tcl-prod-project"
  # Can export to pubsub, cloud storage, or bigquery
  destination = "logging.googleapis.com/projects/tcl-prod-audit-logs-0/locations/us-central1/buckets/audit-logs-prod"

  # Log all WARN or higher severity messages relating to instances
  filter = "projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Factivity OR projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Fsystem_event OR projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Fdata_access OR projects/tcl-prod-project/logs/cloudaudit.googleapis.com%2Fpolicy"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
  
}

resource "google_project_iam_binding" "log-writer" {
  project = "tcl-prod-audit-logs-0"
  role = "roles/logging.bucketWriter"#AND roles/logging.logWriter"

  members = [
    google_logging_project_sink.my-sink.writer_identity,
  ]
}