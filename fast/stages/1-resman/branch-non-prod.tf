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

module "branch-non-prod-folder" {
  source = "../../../modules/folder"
  parent = "organizations/${var.organization.id}"
  name   = "no-prod"
 
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

module "branch-non-prod-gcs" {
  source        = "../../../modules/gcs"
  project_id    = var.automation.project_id
  name          = "non-prod"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.branch-network-sa.iam_email]
  }
}
