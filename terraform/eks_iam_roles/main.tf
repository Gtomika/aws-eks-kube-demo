# the administrative role that the EKS cluster will assume
data "aws_iam_policy_document" "eks_cluster_role_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.app_name}-ClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" # policy managed by AWS
  role       = aws_iam_role.eks_cluster_role.name
}

# the role that individual pods will assume
# this is different for all applications running in the cluster
data "aws_iam_policy_document" "pod_role_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "pod_role" {
  name               = "${var.app_name}-PodRole"
  assume_role_policy = data.aws_iam_policy_document.pod_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "pod_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy" # managed by AWS, allows to get image from ECR
  role       = aws_iam_role.pod_role.arn
}

# could attach more policies to the pods, to allow access. This app does not need any more.