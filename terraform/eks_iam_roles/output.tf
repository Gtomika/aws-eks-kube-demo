output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "pod_role_arn" {
  value = aws_iam_role.pod_role.arn
}