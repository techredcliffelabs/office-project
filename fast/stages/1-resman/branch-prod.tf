/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description Networking stage resources.

module "branch-prod-folder" {
  source = "../../../modules/folder"
  parent = "organizations/${var.organization.id}"
  name   = "prod"
 
  iam = {
    "roles/logging.admin"                  = [module.branch-network-sa.iam_email]
    "roles/owner"                          = [module.branch-network-sa.iam_email]
    "roles/resourcemanager.folderAdmin"    = [module.branch-network-sa.iam_email]
    "roles/resourcemanager.projectCreator" = [module.branch-network-sa.iam_email]
    "roles/compute.xpnAdmin"               = [module.branch-network-sa.iam_email]
    "roles/iam.serviceAccountTokenCreator" = [module.branch-network-sa.iam_email]
    "roles/browser"                        = [module.branch-network-sa.iam_email]
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/teams"].id, null
    )
  }
}

# automation service account and bucket

/*module "branch-prod-gcs" {
  source        = "../../../modules/gcs"
  project_id    = var.automation.project_id
  name          = "prod-env"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.branch-network-sa.iam_email]
  }
}*/

resource "google_logging_folder_sink" "folder-sink-audit-log" {
  name   = "data-access-sink"
  description = "some explanation on what this is"
  folder = module.branch-prod-folder.id
  include_children = true
  # Can export to pubsub, cloud storage, or bigquery
  destination = "logging.googleapis.com/${var.automation.audit-log-bucket}"
  # Log all WARN or higher severity messages relating to instances
  filter = "folders/${module.branch-prod-folder.id}/logs/cloudaudit.googleapis.com%2Fdata_access"
}

resource "google_project_iam_member" "log-writer" {
  project = var.automation.audit-log-project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_folder_sink.folder-sink-audit-log.writer_identity
}