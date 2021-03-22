provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}" 
}

resource "aws_s3_bucket" "tf-root-module-bucket" {
  bucket = "${var.s3_bucket_name}"
  acl = "private"
  region = "${var.s3_bucket_region}"
  
  versioning {
    enabled = true
  }
  
  tags = {
    Name        = "${var.s3_bucket_name}"
    Environment = "${var.tag_env}"
  }
}

resource "aws_s3_bucket_policy" "tf-root-module-bucket"{
  
  policy = jsonencode({
    Version = "2012-10-17"
    Id = "MyBucketPolicy"
    Statement = [
      {
        Sid = "IPAllow"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.tf-root-module-bucket.arn,
          "${aws_s3_bucket.tf-root-module-bucket.arn}/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/24"
          }
        }
      }
    ]
  })
}
