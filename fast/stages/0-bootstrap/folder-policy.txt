resource "google_folder_organization_policy" "allow-externalIp" {
  folder     = "folders/888116622737"
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    allow {
      all = true
    }
  }
}