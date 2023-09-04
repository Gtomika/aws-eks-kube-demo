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