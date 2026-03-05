terraform {
  backend "gcs" {}
}

# Violation 1: Publicly readable Cloud Storage bucket
resource "google_storage_bucket" "public_bucket" {
  name     = "my-public-bucket-test-gcp"
  location = "US"
  uniform_bucket_level_access = true
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  # Making bucket public (Checkov violation)
  iam_binding {
    role = "roles/storage.objectViewer"
    members = ["allUsers"]  # Checkov flags this
  }
}

# Violation 2: Firewall allowing SSH from anywhere
resource "google_compute_firewall" "insecure_firewall" {
  name    = "allow-ssh-anywhere"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Checkov flags this
  direction     = "INGRESS"
}