# output ecs cluster public ip
output "ecs_cluster_runner_ip" {
  description = "External IP of ECS Cluster"
  value = [aws_instance.ecs-cluster-runner.*.public_ip]
}

output "ecs_cluster_name" {
  value = var.app_name
  }

output "target_execution_role" {
  value = aws_iam_role_policy.ecs-cluster-runner-role-policy.name
  }

output "region" {
  value = var.region
  }

output "vpc" {
  value = aws_vpc.aws-vpc.id
  }

output "subnets" {
  value = aws_subnet_aws-subnet.*.id
  }

output "security_groups" {
  value = aws_security_group.ecs-cluster-host.name
  }
