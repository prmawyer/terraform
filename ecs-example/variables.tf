# AWS connection & authentication | variables-auth.tf
variable "aws_access_key" {
  type = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
}
variable "aws_key_pair_name" {
  type = string
  description = "AWS key pair name"
}
variable "aws_key_pair_file" {
  type = string
  description = "Location of AWS key pair file"
}
variable "aws_region" {
  type = string
  description = "AWS region"
}

# ECS cluster variables | variables-network.tf
variable "app_name" {
  type = string
  description = "App being deployed to ECS"
  default = "t2.small"
}

variable "app_environment" {
  type = string
  description = "Environment to which app is deployed"
  default = "Harness-SE-testing"
}
