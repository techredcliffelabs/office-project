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

module "peering-transit-shared" {
  source        = "../../../modules/net-vpc-peering"
  prefix        = "transit-shared-peering"
  local_network = module.transit-vpc.self_link
  peer_network  = module.shared-resources-vpc.self_link
  export_local_custom_routes = try(
    var.peering_configs.shared-resources.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.shared-resources.export_peer_custom_routes, null
  )
}

module "peering-transit-dev" {
  source        = "../../../modules/net-vpc-peering"
  prefix        = "transit-dev-peering"
  local_network = module.transit-vpc.self_link
  peer_network  = module.dev-vpc.self_link
  #depends_on    = [module.peering-dev]
  export_local_custom_routes = try(
    var.peering_configs.dev.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.dev.export_peer_custom_routes, null
  )
}

module "peering-transit-qa" {
  source        = "../../../modules/net-vpc-peering"
  prefix        = "transit-qa-peering"
  local_network = module.transit-vpc.self_link
  peer_network  = module.qa-vpc.self_link
  #depends_on    = [module.peering-dev]
  export_local_custom_routes = try(
    var.peering_configs.qa.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.qa.export_peer_custom_routes, null
  )
}

module "peering-transit-prod" {
  source        = "../../../modules/net-vpc-peering"
  prefix        = "transit-prod-peering"
  local_network = module.transit-vpc.self_link
  peer_network  = module.prod-vpc.self_link
  #depends_on    = [module.peering-dev]
  export_local_custom_routes = try(
    var.peering_configs.prod.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.prod.export_peer_custom_routes, null
  )
}

module "peering-shared-resources-dev" {
  source        = "../../../modules/net-vpc-peering"
  prefix        = "shared-resources-dev-peering"
  local_network = module.shared-resources-vpc.self_link
  peer_network  = module.dev-vpc.self_link
  #depends_on    = [module.peering-dev]
  export_local_custom_routes = try(
    var.peering_configs.dev.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.dev.export_peer_custom_routes, null
  )
}

module "peering-shared-resources-qa" {
  source        = "../../../modules/net-vpc-peering"
  prefix        = "shared-resources-qa-peering"
  local_network = module.shared-resources-vpc.self_link
  peer_network  = module.qa-vpc.self_link
  #depends_on    = [module.peering-dev]
  export_local_custom_routes = try(
    var.peering_configs.qa.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.qa.export_peer_custom_routes, null
  )
}

module "peering-shared-resources-prod" {
  source        = "../../../modules/net-vpc-peering"
  prefix        = "shared-resources-prod-peering"
  local_network = module.shared-resources-vpc.self_link
  peer_network  = module.prod-vpc.self_link
  #depends_on    = [module.peering-dev]
  export_local_custom_routes = try(
    var.peering_configs.prod.export_local_custom_routes, null
  )
  export_peer_custom_routes = try(
    var.peering_configs.prod.export_peer_custom_routes, null
  )
}

