module "qa-project" {
  source          = "../../../modules/project"
  billing_account = var.billing_account.id
  name            = "qa-project"
  parent          = var.folder_ids.non-prod
  prefix          = var.prefix
  services = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "stackdriver.googleapis.com"
  ]
  iam = {
    "roles/dns.admin" = compact([
      try(local.service_accounts.project-factory-prod, null)
    ])
    (local.custom_roles.service_project_network_admin) = compact([
      try(local.service_accounts.project-factory-prod, null)
    ])
  }
  auto_create_network = "false"
}

resource "google_compute_shared_vpc_service_project" "service-qa" {
  host_project    = module.host-project.project_id
  service_project = module.qa-project.project_id
  #network         = module.dev-vpc.self_link
}


