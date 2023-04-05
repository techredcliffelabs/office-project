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

# tfdoc:file:description Landing VPC and related resources.

module "host-project" {
  source          = "../../../modules/project"
  billing_account = var.billing_account.id
  name            = "vpc-host"
  parent          = var.folder_ids.networking
  prefix          = var.prefix
  services = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "stackdriver.googleapis.com"
  ]
  shared_vpc_host_config = {
    enabled = true
  }
  iam = {
    "roles/dns.admin" = compact([
      try(local.service_accounts.project-factory-prod, null)
    ])
    (local.custom_roles.service_project_network_admin) = compact([
      try(local.service_accounts.project-factory-prod, null)
    ])
  }
}


/*
resource "google_organization_policy" "shared_vpc_policy" {
  
  constraint = "constraints/compute.restrictSharedVpcHostProjects"
  enforcement_mode = "DENY"
}
*/

module "transit-vpc" {
  source     = "../../../modules/net-vpc"
  project_id = module.host-project.project_id
  name       = "transit-vpc"
  mtu        = 1500
  dns_policy = {
    inbound = true
  }
  # set explicit routes for googleapis in case the default route is deleted
  routes = {
    private-googleapis = {
      dest_range    = "199.36.153.8/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
    restricted-googleapis = {
      dest_range    = "199.36.153.4/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
  }
  data_folder = "${var.factories_config.data_dir}/subnets/transit"
}

module "shared-resources-vpc" {
  source     = "../../../modules/net-vpc"
  project_id = module.host-project.project_id
  name       = "shared-resources-vpc"
  mtu        = 1500
  dns_policy = {
    inbound = true
  }
  # set explicit routes for googleapis in case the default route is deleted
  routes = {
    private-googleapis = {
      dest_range    = "199.36.153.8/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
    restricted-googleapis = {
      dest_range    = "199.36.153.4/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
  }
  data_folder = "${var.factories_config.data_dir}/subnets/shared-resources"
}

module "dev-vpc" {
  source     = "../../../modules/net-vpc"
  project_id = module.host-project.project_id
  name       = "dev-vpc"
  mtu        = 1500
  dns_policy = {
    inbound = true
  }
  # set explicit routes for googleapis in case the default route is deleted
  routes = {
    private-googleapis = {
      dest_range    = "199.36.153.8/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
    restricted-googleapis = {
      dest_range    = "199.36.153.4/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
  }
  data_folder = "${var.factories_config.data_dir}/subnets/dev"
}

module "qa-vpc" {
  source     = "../../../modules/net-vpc"
  project_id = module.host-project.project_id
  name       = "qa-vpc"
  mtu        = 1500
  dns_policy = {
    inbound = true
  }
  # set explicit routes for googleapis in case the default route is deleted
  routes = {
    private-googleapis = {
      dest_range    = "199.36.153.8/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
    restricted-googleapis = {
      dest_range    = "199.36.153.4/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
  }
  data_folder = "${var.factories_config.data_dir}/subnets/qa"
}

module "prod-vpc" {
  source     = "../../../modules/net-vpc"
  project_id = module.host-project.project_id
  name       = "prod-vpc"
  mtu        = 1500
  dns_policy = {
    inbound = true
  }
  # set explicit routes for googleapis in case the default route is deleted
  routes = {
    private-googleapis = {
      dest_range    = "199.36.153.8/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
    restricted-googleapis = {
      dest_range    = "199.36.153.4/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
  }
  data_folder = "${var.factories_config.data_dir}/subnets/prod"
}

/*module "host-firewall" {
  source     = "../../../modules/net-vpc-firewall"
  project_id = module.host-project.project_id
  network    = module.landing-vpc.name
  default_rules_config = {
    disabled = true
  }
  factories_config = {
    cidr_tpl_file = "${var.factories_config.data_dir}/cidrs.yaml"
    rules_folder  = "${var.factories_config.data_dir}/firewall-rules/landing"
  }
}

moved {
  from = module.landing-nat-ew1
  to   = module.landing-nat-primary
}*/

module "transit-nat-primary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.primary
  name           = "transit-nat"
  router_create  = true
  router_name    = "transit-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.transit-vpc.name
  router_asn     = 4200001024
}

module "shared-resources-nat-primary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.primary
  name           = "shared-resources-nat"
  router_create  = true
  router_name    = "shared-resources-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.shared-resources-vpc.name
  router_asn     = 4200001024
}

module "dev-nat-primary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.primary
  name           = "dev-nat"
  router_create  = true
  router_name    = "dev-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.dev-vpc.name
  router_asn     = 4200001024
}

module "qa-nat-primary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.primary
  name           = "qa-nat"
  router_create  = true
  router_name    = "qa-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.qa-vpc.name
  router_asn     = 4200001024
}

module "prod-nat-primary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.primary
  name           = "prod1-nat"
  router_create  = true
  router_name    = "prod1-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.prod-vpc.name
  router_asn     = 4200001024
}




module "transit-nat-secondary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.secondary
  name           = "transit-dr-nat"
  router_create  = true
  router_name    = "transit-dr-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.transit-vpc.name
  router_asn     = 4200001024
}

module "shared-resources-nat-secondary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.secondary
  name           = "shared-resources-dr-nat"
  router_create  = true
  router_name    = "shared-resources-dr-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.shared-resources-vpc.name
  router_asn     = 4200001024
}

module "dev-nat-secondary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.secondary
  name           = "dev-dr-nat"
  router_create  = true
  router_name    = "dev-dr-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.dev-vpc.name
  router_asn     = 4200001024
}

module "qa-nat-secondary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.secondary
  name           = "qa-dr-nat"
  router_create  = true
  router_name    = "qa-dr-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.qa-vpc.name
  router_asn     = 4200001024
}

module "prod-nat-secondary" {
  source         = "../../../modules/net-cloudnat"
  project_id     = module.host-project.project_id
  region         = var.regions.secondary
  name           = "prod1-dr-nat"
  router_create  = true
  router_name    = "prod1-dr-nat-${local.region_shortnames[var.regions.primary]}"
  router_network = module.prod-vpc.name
  router_asn     = 4200001024
}
