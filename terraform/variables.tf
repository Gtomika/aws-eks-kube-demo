# Following variables must be passed from outside ----------------------------------------------

variable "cluster_name" {
  type = string
  description = "Name of EKS cluster"
}

variable "kube_namespace" {
  type = string
  description = "Kube namespace for this demo app"
}

variable "aws_key_id" {
  type = string
  sensitive = true
  description = "AWS access key ID of the CICD pipeline IAM user"
}

variable "aws_secret_key" {
  type = string
  sensitive = true
  description = "AWS secret key of the CICD pipeline IAM user"
}

variable "aws_sts_external_id" {
  type = string
  sensitive = true
  description = "Additional protection string when assuming Terraform role"
}

# Following variables have default values ----------------------------------------------

variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "availability_zones" {
  type = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
  description = "AZs to place the EKS cluster into"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
  default = ["10.0.0.0/26", "10.0.0.64/26"]
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
  default = ["10.0.0.128/26", "10.0.0.192/26"]
}

variable "app_name" {
  type = string
  default = "AwsEksKubeDemo"
  description = "Used in resource naming"
}

variable "aws_terraform_role_arn" {
  type = string
  default = "arn:aws:iam::844933496707:role/TerraformRole"
  description = "The role that Terraform assumes to plan and modify"
}

variable "my_cli_role_arn" {
  type = string
  default = "arn:aws:iam::844933496707:role/gaspar-tamas-cli-role"
  description = "Role that I use on my machine to manage AWS"
}

variable "ci_cd_user_arn" {
  type = string
  default = "arn:aws:iam::844933496707:user/aws-kube-demo-cicd"
  description = "IAM user that GitHub actions uses"
}
