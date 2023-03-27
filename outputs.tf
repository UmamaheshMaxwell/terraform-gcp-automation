output "target_pool" {
  description = "Self link of the target pool"
  value       = google_compute_target_pool.tf_target_pool.self_link
}