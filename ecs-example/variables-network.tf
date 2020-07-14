# ECS cluster variables | variables-network.tf
variable "app_name" {
  type = string
  description = "App being deployed to ECS"
  default = "t2.small"
}
