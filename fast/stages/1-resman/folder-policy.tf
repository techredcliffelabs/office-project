resource "google_folder_organization_policy" "allow-externalIp" {
  folder     = module.branch-prod-folder.id
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_folder_organization_policy" "prod-restrict-sharedVPC-host" {
  folder     = module.branch-prod-folder.id
  constraint = "compute.restrictSharedVpcHostProjects"

  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_folder_organization_policy" "non-prod-restrict-sharedVPC-host" {
  folder     = module.branch-non-prod-folder.id
  constraint = "compute.restrictSharedVpcHostProjects"

  list_policy {
    allow {
      all = true
    }
  }
}