output "nameservers" {
  value = data.google_dns_record_set.tf_record_set.rrdatas
}
