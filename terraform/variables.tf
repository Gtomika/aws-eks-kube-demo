# Following variables must be passed from outside ----------------------------------------------

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

# Following variables have default values ----------------------------------------------

variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "availability_zones" {
  type = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
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
}

# role that holds permissions, assumed by Terraform
variable "aws_terraform_role_arn" {
  type = string
  default = "arn:aws:iam::844933496707:role/TerraformRole"
}
