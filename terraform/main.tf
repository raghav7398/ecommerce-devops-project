terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "raghav-7398-backend"
    region         = "us-east-1"
    key            = "terraform.tfstate"
    dynamodb_table = "backend"

  }
}

module "VPC" {
  source            = "./modules/VPC"
  vpc_name          = var.vpc_name
  vpc_cidr          = var.vpc_cidr
  public_cidr       = var.public_cidr
  private_cidr      = var.private_cidr
  availability_zone = var.availability_zone

}

module "EKS" {
  source          = "./modules/EKS"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.VPC.private_subnet_id
  node_groups     = var.node_groups

}