terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

######## Defining required Variables ########################

variable "eks_name"  {
  description = "eks cluster name"
}
variable "eks_role"  {
  description = "eks role name"
}
variable "vpc_cidr"  {
  description = "vpc cidr value"
}
variable "vpc_name"  {
  description = "vpc cidr value"
}
variable "aurora_name"  {
  description = "Aurora instance name"
}
variable "db_user"  {
  description = "Postgres DB username"
}
variable "db_password"  {
  description = "postgres db password"
}
variable "db_port"  {
  description = "postgres db port"
}
variable "db_name"  {
  description = "postgres db name"
}

variable "private_subnets"  {
  description = "private subnets"
}
variable "public_subnets"  {
  description = "public subnets"
}

data "aws_availability_zones" "available" {}

####### Block for spinning up vpc  ###########

module "vpc_cake_test" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name 		       = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

############ Block for creating an EKS cluster and its dependencies #############
  
resource "aws_iam_role" "eks_role" {
  name = var.eks_role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [module.vpc_cake_test.private_subnets[0], module.vpc_cake_test.private_subnets[1]]
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
  ]
}

###### Creating Aurora  ########

module "aurora_postgresql"  {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.1.0"

  name 				= var.aurora_name
  engine			= "aurora-postgresql"
  engine_version	        = "11.9"
  vpc_id			= module.vpc_cake_test.vpc_id
  subnets 			= [ module.vpc_cake_test.private_subnets[0], module.vpc_cake_test.private_subnets[1]]
  instance_class        	= "db.t4.large"
  storage_encrypted    		= true
  master_username             	= var.db_name
  master_password             	= var.db_password
  port                 		= var.db_port
  database_name        		= var.db_name
}
