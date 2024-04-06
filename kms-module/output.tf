output "crypto_sql_key_id" {
  value = google_kms_crypto_key.sql-key.id
}

output "crypto_bucket_key_id" {
  value = google_kms_crypto_key.bucket-key.id
}

output "crypto_vm_key_id" {
  value = google_kms_crypto_key.vm-key.id
}

