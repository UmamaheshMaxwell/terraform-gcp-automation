resource "google_cloudbuild_trigger" "tfd_cloud_build" {
  location = "us-central1"
  name = "node-cloud-build"

  trigger_template {
    branch_name = "main"
    repo_name   = data.google_sourcerepo_repository.tf_sourcerepo.name
  }

  filename = "cloudbuild.yaml"
}

data "google_sourcerepo_repository" "tf_sourcerepo" {
  name = "github_umamaheshmaxwell_node-cloud-build"
}

output "repo" {
    value = data.google_sourcerepo_repository.tf_sourcerepo.name
}