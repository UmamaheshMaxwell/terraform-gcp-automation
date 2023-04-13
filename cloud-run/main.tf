/*
    * This is needed for cloud run 
*/
locals {
  service_account = "terraform@gcp-training-377619.iam.gserviceaccount.com"
  instances = [google_cloud_run_service.tf_cloud_run1, google_cloud_run_service.tf_cloud_run2]
}

/*
    * This is needed to enable "Allow Unauthenticated"
*/

data "google_iam_policy" "tf_no_auth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "tf_no_auth" {
  for_each = {
    for key, value in local.instances : key => value
  }
  service  = each.value.name
  location = each.value.location
  project  = each.value.project
  policy_data = data.google_iam_policy.tf_no_auth.policy_data
}

resource "google_cloud_run_service" "tf_cloud_run1" {
  name     = "node-app-service"
  location = "us-central1"

  template {
    spec {
      containers {
        // Make sure your image is avilabe with in google container registry
        image = "gcr.io/gcp-training-377619/node-app:v1"
      }
      service_account_name = local.service_account
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "tf_cloud_run2" {
  name     = "cloud-run-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
      service_account_name = local.service_account
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}
