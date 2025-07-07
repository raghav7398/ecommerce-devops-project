output "cluster_name" {
    value = aws_eks_cluster.example.name
  
}

output "cluster_endpoint" {
    value = aws_eks_cluster.example.endpoint
  
}