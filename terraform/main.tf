# Generate a random string to ensure the bucket name is globally unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# The Cloud Storage Bucket configured to host a static website
resource "google_storage_bucket" "website" {
  name          = "${var.bucket_name_prefix}-${random_id.bucket_suffix.hex}"
  location      = var.region
  force_destroy = true # Allows deleting the bucket even if it contains objects (useful for testing/learning)

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html" # For React Router support (SPA)
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "OPTIONS"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

# Make the objects inside the bucket publicly readable
resource "google_storage_bucket_iam_binding" "public_rule" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}
