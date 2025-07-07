variable "vpc_cidr" {
  description = "CIDR block of vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "ecommerce-vpc"

}

variable "public_cidr" {
  type        = list(string)
  description = "CIDR block of public subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "availability_zone" {
  type        = list(string)
  description = "Availability zone for subnets"
  default     = ["us-east-1a", "us-east-1b"]

}

variable "private_cidr" {
  type        = list(string)
  description = "CIDR block of private subnet"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]

}

variable "cluster_name" {
  type    = string
  default = "ecommerce-cluster"

}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "node_groups" {
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  default = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 1
      }

    }

  }
}

