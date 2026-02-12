terraform {
    source = "../../../modules/google_cloud_storage"
}

inputs = {
  bucket_name        = "test_bucket"
  location           = "europe-west2"
  force_destroy      = false
  versioning_enabled = true
}

include {
    path = find_in_parent_folders("root.hcl")
}