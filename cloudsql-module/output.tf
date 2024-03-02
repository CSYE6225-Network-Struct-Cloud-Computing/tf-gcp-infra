output "database_name" {
  value = google_sql_database.database.name
}

output "db_username" {
  value = google_sql_user.users.name
}

output "db_password" {
  value = google_sql_user.users.password
}

output "internal_ip" {
  value = google_compute_address.default.address
}
