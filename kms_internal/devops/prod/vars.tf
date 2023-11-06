data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

variable "aws_access_key" {}
variable "aws_secret_key" {
  sensitive = true
}

variable "region" {
  description = "The region of the application (need for migrating to different regions)"
  default     = "us-east-1"
}

variable "app_name" {
  description = "The name of the application"
  default     = "nagios-portal"
}

variable "cidr" {
  description = "The network of the application"
  default     = "10.0.0.0/16"
}

# variable "module_version" {
#   description = "The version of EKS module"
#   default = "19.15.3"
# }

# variable "eks_version" {
#   description = "The version of K8s"
#   default = "1.27"
# }

variable "instance_type" {
  description = "The instance type of AWS"
  default     = "t2.large"
}

variable "ami_type" {
  description = "The ami for each node"
  default     = "ami-0aedf6b1cb669b4c7"
}