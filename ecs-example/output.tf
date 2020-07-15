output "ecs_cluster_name" {
  value = var.app_name
  }

output "target_execution_role" {
  value = aws_iam_role.ecsTaskExecutionRole.name
  }

output "region" {
  value = var.region
  }

output "vpc" {
  value = aws_vpc.aws-vpc.arn
  }

output "subnets" {
  value = aws_subnet.aws-subnet.*.arn
  }

output "security_groups" {
  value = aws_security_group.ecs-cluster-host.*.name
  }
