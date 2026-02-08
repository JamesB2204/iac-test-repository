remote_state {
    backend = "gcs"
    config = {
        project = "iac-pipeline"
        bucket  = "state-store"
        prefix = "terraform.tfstate"
        location = "europe-west2"
    }
}