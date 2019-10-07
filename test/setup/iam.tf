locals {
  vm_required_roles = [
    "roles/owner",
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountUser",
    "roles/compute.instanceAdmin",
  ]
}

resource "google_service_account" "ci_vm_account" {
  project      = module.project_ci_vm.project_id
  account_id   = "ci-vm-account"
  display_name = "ci-vm-account"
}

resource "google_project_iam_member" "ci_vm_account" {
  count = length(local.vm_required_roles)

  project = module.project_ci_vm.project_id
  role    = local.vm_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.ci_vm_account.email}"
}

resource "google_service_account_key" "ci_vm_account" {
  service_account_id = google_service_account.ci_vm_account.id
}
