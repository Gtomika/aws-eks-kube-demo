variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "availability_zones" {
  type = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "app_name" {
  type = string
  default = "AwsEksKubeDemo"
}

variable "cluster_name" {
  type = string
}

variable "kube_namespace" {
  type = string
}

# it's just for assuming role, does not have any other permissions
variable "aws_key_id" {
  type = string
  sensitive = true
}

# it's just for assuming role, does not have any other permissions
variable "aws_secret_key" {
  type = string
  sensitive = true
}

# additional protection for assuming the role
variable "aws_sts_external_id" {
  type = string
  sensitive = true
}

# role that holds permissions, assumed by Terraform
variable "aws_terraform_role_arn" {
  type = string
  default = "arn:aws:iam::844933496707:role/TerraformRole"
}
