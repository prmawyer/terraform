variable "access_key" {}
variable "secret_key" {}

variable "service_name" {
  type        = "string"
  description = "Name of Service being deployed"
  default     = "patrick-terraform-test"
  }

variable "region" {
  type        = "string"
  description = "AWS Region required by Terraform AWS Provider"
  default     = "us-east-1"
  }

variable "s3_bucket_region" {
  type        = "string"
  description = "Region where S3 bucket will be created used to store remote state file"
  default     = "us-east-1"
  }

variable "s3_bucket_name" {
  type        = "string"
  description = "Name of the S3 bucket to be created used to store the remote state file"
  default     = "patrick-harness"
  }

variable "tag_env" {
  type        = "string"
  description = "Tag for Environment Name"
  default     = "patrick-harness-se-testing"
  }
