backend "s3" {
   bucket = "patrick-harness"
   key = "terraform.tfstate"
   region = "us-east-1"
  }

provider "aws" {
   region = var.aws_region
   access_key = var.aws_access_key
   secret_key = var.aws_secret_key
}
