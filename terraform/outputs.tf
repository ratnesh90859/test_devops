output "website_url" {
  description = "The public URL to access your deployed React application."
  value       = "http://storage.googleapis.com/${google_storage_bucket.website.name}/index.html"
}

output "bucket_name" {
  description = "The name of the generated GCS bucket. Use this in your Jenkins CI/CD pipeline."
  value       = google_storage_bucket.website.name
}
