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

output "vpc" {
  }

output "subnets" {
  }

output "security_groups" {
  }
