output "vpc_id" {
  value = module.VPC.vpc_id

}
output "private_subnet_id" {
  value = module.VPC.private_subnet_id
}

output "public_subnet_id" {
  value = module.VPC.public_subnet_id

}

output "cluster_name" {
  value = module.EKS.cluster_name

}

output "cluster_endpoint" {
  value = module.EKS.cluster_endpoint

}