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

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name = var.cluster_name
  cluster_version = "1.19"
  cluster_endpoint_public_access = true
  vpc_id = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)

  # configure fargate profile that runs pods -----------------------------------
  fargate_profiles = {
    default = {
      name = "${var.app_name}-FargateProfile"
      selectors = [{
        namespace = var.kube_namespace
      }]
      subnet_ids = module.vpc.private_subnet_ids
    }
  }

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  # configure which roles can access the cluster -----------------------------------
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {  # added so that I can manage the cluster too from my machine
      rolearn = var.my_cli_role
      username = admin_cli
      groups   = ["system:masters"]
    },
    { # added so Ci/Cd pipeline can assume this role and deploy
      rolearn = module.eks_iam_roles.management_role_arn
      username = ci_ci_pipeline
      groups   = ["system:masters"]
    }
  ]
}
