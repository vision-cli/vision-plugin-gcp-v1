module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name              = "${var.project_name}-${var.environment}-${var.unique_str}"
  random_project_id = false
  org_id            = var.org_id
  billing_account   = var.billing_account
  folder_id         = var.folder_id

  activate_apis = [
    "compute.googleapis.com",               # Needed for networking
    "iam.googleapis.com",                   # Needed for terraform to create and manage accounts
    "iap.googleapis.com",                   # Needed for terraform to creete and manage IAP
    "run.googleapis.com",                   # Needed for Cloud Run
    "vpcaccess.googleapis.com",             # Needed for private network
    "servicenetworking.googleapis.com",     # Needed for private network interconnect
    "cloudresourcemanager.googleapis.com",  # Needed for terraform to create and manage containers
    "serviceusage.googleapis.com",          # Needed for terraform to create and manage containers
    "sqladmin.googleapis.com",              # Needed for terraform to create and manage SQL
  ]
}

resource "google_project_service_identity" "cloudrun_sa" {
  provider = google-beta

  project = module.project.project_id
  service = "iap.googleapis.com"
}
