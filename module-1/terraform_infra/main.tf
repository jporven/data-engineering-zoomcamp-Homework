terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }

    b2 = {
      source = "Backblaze/b2"
    }

  }

}
provider "b2" {
  application_key_id = var.b2_key_id
  application_key    = var.b2_key
}


provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}


# resource "google_storage_bucket" "demo-bucket" {
#   name          = var.gcs_bucket_name
#   location      = var.location
#   force_destroy = true


#   lifecycle_rule {
#     condition {
#       age = 1
#     }
#     action {
#       type = "AbortIncompleteMultipartUpload"
#     }
#   }
# }


resource "b2_bucket" "example_bucket" {
  bucket_name = "demodataset"
  bucket_type = "allPrivate"
  lifecycle_rules {
    file_name_prefix              = ""
    days_from_hiding_to_deleting  = 1
    days_from_uploading_to_hiding = null
  }
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
  default_table_expiration_ms = 5184000000
  default_partition_expiration_ms = 5184000000
}