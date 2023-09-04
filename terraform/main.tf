# VPC and subnets setup in which the control pane and pods will run
module "vpc" {
  source = "./vpc"
  app_name = var.app_name
  availability_zones = var.availability_zones
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  cluster_name = var.cluster_name
}

# roles required for control pane and pods
module "eks_iam_roles" {
  source = "./eks_iam_roles"
  app_name = var.app_name
}

resource "aws_eks_cluster" "demo_cluster" {
  name     = var.cluster_name
  role_arn = module.eks_iam_roles.eks_cluster_role_arn
  vpc_config {
    subnet_ids = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  }
}

# the pods of the app will run in using this configurations
# another way would be to define EC2 instance types to run pods
resource "aws_eks_fargate_profile" "demo_fargate_profile" {
  cluster_name           = aws_eks_cluster.demo_cluster.name
  fargate_profile_name   = "${var.app_name}-FargateProfile"
  pod_execution_role_arn = module.eks_iam_roles.pod_role_arn
  subnet_ids = module.vpc.private_subnet_ids
  selector { # defines which pods will be run using this profile
    namespace = var.kube_namespace
  }

  depends_on = [aws_eks_cluster.demo_cluster]
}