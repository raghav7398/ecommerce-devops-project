variable "vpc_cidr" {
    description = "CIDR block of vpc"
    type = string
}

variable "vpc_name" {
    description = "Name of the VPC"
    type = string
}

variable "public_cidr" {
    type = list(string)
    description = "CIDR block of public subnet"
   
  
}

variable "availability_zone" {
    type = list(string)
    description = "Availability zone for subnets"

  
}

variable "private_cidr" {
    type = list(string)
    description = "CIDR block of private subnet"
   
  
}