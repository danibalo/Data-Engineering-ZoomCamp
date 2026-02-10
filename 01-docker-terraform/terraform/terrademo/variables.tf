variable "credentials" {
  description = "My Credentials"
  default     = "./keys/my-creds.json"
}
variable "project" {
  description = "Project"
  default     = "spry-dispatcher-486915-q5"

}
variable "region" {
  description = "Region"
  default     = "us-east-1"
}
variable "location" {
  description = "Project Location"
  default     = "US"

}


variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "demo_dataset"

}
variable "gcs_bucket_name" {
  description = "My Storage Dataset Name"
  default     = "spry-dispatcher-486915-q5"
}
