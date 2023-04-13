/*
    * This script will assign multiple roles to the user(email)
*/

resource "google_project_iam_member" "tf_add_roles" {
    for_each = toset([
        "roles/iam.roleAdmin",
        "roles/iam.securityAdmin",
        "roles/iam.serviceAccountUser",
        "roles/iam.serviceAccountAdmin"
    ])
    role = each.value
    member = "user:${var.email}"
    project = var.project
}

