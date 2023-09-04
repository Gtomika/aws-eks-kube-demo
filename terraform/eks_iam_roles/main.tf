# the role that individual pods will assume ------------------------------------------------------------
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

# could attach more policies to the pods, to allow access to other AWS resources. This app does not need any more.
resource "aws_iam_role_policy_attachment" "pod_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy" # managed by AWS, allows to get image from ECR
  role       = aws_iam_role.pod_role.name
}

data "aws_caller_identity" "current_aws_session" {}

# the role that cluster management tools will assume (such as a CI pipeline to deploy to this cluster)
data "aws_iam_policy_document" "management_role_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current_aws_session.account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "management_role_policy" {
  statement {
    effect = "Allow"
    actions = ["eks:DescribeCluster"] # this is all that is needed to create Kube config file and connect
    resources = ["*"]
  }
}

resource "aws_iam_role" "management_role" {
  name = "${var.app_name}-ManagementRole"
  assume_role_policy = data.aws_iam_policy_document.management_role_trust_policy
}

resource "aws_iam_policy" "eks_describe_policy" {
  name = "${var.app_name}-ManagementPolicy"
  policy = data.aws_iam_policy_document.management_role_policy
}

resource "aws_iam_role_policy_attachment" "management_role_attachment" {
  policy_arn = aws_iam_policy.eks_describe_policy.arn
  role       = aws_iam_role.management_role.name
}