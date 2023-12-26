provider "google" {
  project = "local-concord-408802"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

####==============================================================================
#### vpc module call.
####==============================================================================
module "vpc" {
  source                                    = "git::git@github.com:opsstation/terraform-gcp-vpc.git?ref=master"
  name                                      = "app"
  environment                               = "test"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

####==============================================================================
#### interconnect_attachment module call.
####==============================================================================
module "cloud_router" {
  source                          = "../../"
  name                            = "app"
  environment                     = "test"
  region                          = "asia-northeast1"
  network                         = module.vpc.vpc_id
  enabled_interconnect_attachment = true
  #  interconnect = "https://googleapis.com/interconnects/example-interconnect"

  bgp = {
    asn               = "16550"
    advertised_groups = ["ALL_SUBNETS"]
  }
}