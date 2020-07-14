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
