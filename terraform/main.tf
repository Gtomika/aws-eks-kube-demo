data "aws_caller_identity" "aws_identity" {}

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

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name = var.cluster_name
  cluster_version = "1.27"
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
  aws_auth_roles = [{  # added so that I can manage the cluster too from my machine
    rolearn = var.my_cli_role_arn
    username = "admin_cli"
    groups   = ["system:masters"]
  }]
  aws_auth_users = [{
    userarn = var.ci_cd_user_arn
    username = "ci_cd_pipeline"
    groups   = ["system:masters"]
  }]
}

# adds the AWS load balancer controller to the cluster
module "aws_eks_load_balancer_controller" {
  source = "lablabs/eks-load-balancer-controller/aws"
  enabled = true
  cluster_name                     = module.eks.cluster_name
  cluster_identity_oidc_issuer     = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}

data "aws_eks_cluster_auth" "clusterauth" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.clusterauth.token
}
