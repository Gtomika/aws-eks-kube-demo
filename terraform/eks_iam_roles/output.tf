output "management_role_arn" {
  value = aws_iam_role.management_role.arn
}

output "pod_role_arn" {
  value = aws_iam_role.pod_role.arn
}