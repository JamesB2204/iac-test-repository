remote_state {
    backend = "gcs"
    config = {
        project = "iac-pipeline"
        bucket  = "state-store"
        prefix  = "${path_relative_to_include()}"
        location = "europe-west2"
    }
}