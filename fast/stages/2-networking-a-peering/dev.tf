module "dev-project" {
  source          = "../../../modules/project"
  billing_account = var.billing_account.id
  name            = "dev-project1"
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

resource "google_compute_shared_vpc_service_project" "service-dev" {
  host_project    = module.host-project.project_id
  service_project = module.dev-project.project_id
  #network         = module.dev-vpc.self_link
}
/*
locals{
  for_each = module.dev-vpc.subnet_id
  
}*/

resource "google_project_organization_policy" "services_policy" {
  #for_each = module.dev-vpc.subnet_id
  project    = module.dev-project.project_id
  constraint = "constraints/compute.restrictSharedVpcSubnetworks"

  list_policy {
    allow {
      values = tolist(values(module.dev-vpc.subnet_id))
    }
  }
}

