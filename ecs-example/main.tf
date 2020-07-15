terraform {
   backend "s3" {
      bucket = "patrick-harness"
      key = "terraform.state"
      region = "us-east-1"
   }
}

provider "aws" {
   region = var.region
   access_key = var.aws_access_key
   secret_key = var.aws_secret_key
}

# Network Setup: VPC, Subnet, IGW, Routes | network.tf
data "aws_availability_zones" "aws-az" {
  state = "available"
}
# create vpc
resource "aws_vpc" "aws-vpc" {
  cidr_block = "10.31.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.app_name}-vpc"
    Environment = var.app_environment
  }
}
# create subnets
resource "aws_subnet" "aws-subnet" {
  count = length(data.aws_availability_zones.aws-az.names)
  vpc_id = aws_vpc.aws-vpc.id
  cidr_block = cidrsubnet(aws_vpc.aws-vpc.cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.aws-az.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.app_name}-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}
# create internet gateway
resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.app_name}-igw"
    Environment = var.app_environment
  }
}
# create routes
resource "aws_route_table" "aws-route-table" {
  vpc_id = aws_vpc.aws-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-igw.id
  }
  tags = {
    Name = "${var.app_name}-route-table"
    Environment = var.app_environment
  }
}
resource "aws_main_route_table_association" "aws-route-table-association" {
  vpc_id = aws_vpc.aws-vpc.id
  route_table_id = aws_route_table.aws-route-table.id
}

# define & build the ecs cluster | ecs-cluster.tf
# create ecs cluster
resource "aws_ecs_cluster" "aws-ecs" {
  name = var.app_name
}

# ecs cluster runner role policies
resource "aws_iam_role" "ecs-cluster-runner-role" {
  name = "${var.app_name}-cluster-runner-role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role.json
}
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "ecs-cluster-runner-policy" {
  statement {
    actions = ["ec2:Describe*", "ecr:Describe*", "ecr:BatchGet*"]
    resources = ["*"]
  }
  statement {
    actions = ["ecs:*"]
    resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:service/${var.app_name}/*"]
  }
}
resource "aws_iam_role_policy" "ecs-cluster-runner-role-policy" {
  name = "${var.app_name}-cluster-runner-policy"
  role = aws_iam_role.ecs-cluster-runner-role.name
  policy = data.aws_iam_policy_document.ecs-cluster-runner-policy.json
}
resource "aws_iam_instance_profile" "ecs-cluster-runner-profile" {
  name = "${var.app_name}-cluster-runner-iam-profile"
  role = aws_iam_role.ecs-cluster-runner-role.name
}

# create security group and security rules for the ecs cluster
resource "aws_security_group" "ecs-cluster-host" {
  name = "${var.app_name}-ecs-cluster-host"
  description = "${var.app_name}-ecs-cluster-host"
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.app_name}-ecs-cluster-host"
    Environment = var.app_environment
    Role = "ecs-cluster"
  }
}
resource "aws_security_group_rule" "ecs-cluster-host-ssh" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "admin SSH access to ecs cluster"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ecs-cluster-egress" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "ecs cluster egress"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
