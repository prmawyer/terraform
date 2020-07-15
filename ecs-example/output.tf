# output ecs cluster public ip
output "ecs_cluster_runner_ip" {
  description = "External IP of ECS Cluster"
  value = [aws_instance.ecs-cluster-runner.*.public_ip]
}

output "ecs_cluster_name" {
  value = var.app_name
  }

output "target_execution_role" {
  value = var.app_name
  }

output "region" {
  value = var.region
  }

output "vpc" {
  value = 
  }

output "subnets" {
  value = 
  }

output "security_groups" {
  value = 
  }
