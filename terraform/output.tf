output "eks_cluster_endpoint" {
  value = aws_eks_cluster.demo_cluster.endpoint
}