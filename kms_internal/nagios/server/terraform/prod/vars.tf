data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
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