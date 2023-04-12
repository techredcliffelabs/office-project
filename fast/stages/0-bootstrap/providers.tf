terraform {
  backend "gcs" {
    bucket                      = "arch1-prod-iac-core-bootstrap-0"
    impersonate_service_account = "arch1-prod-bootstrap-0@arch1-prod-iac-core-0.iam.gserviceaccount.com"
  }
}
/*provider "google" {
  impersonate_service_account = "arch1-prod-resman-0@arch1-prod-iac-core-0.iam.gserviceaccount.com"
}
provider "google-beta" {
  impersonate_service_account = "arch1-prod-resman-0@arch1-prod-iac-core-0.iam.gserviceaccount.com"
}

# end provider.tf for resman*/
