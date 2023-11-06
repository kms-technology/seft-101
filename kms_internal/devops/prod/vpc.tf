module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.app_name}-vpc"
  cidr = var.cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = [
    cidrsubnet(var.cidr, 8, 1),
    cidrsubnet(var.cidr, 8, 2),
    cidrsubnet(var.cidr, 8, 3)
  ]
  public_subnets = [
    cidrsubnet(var.cidr, 8, 4),
    cidrsubnet(var.cidr, 8, 5),
    cidrsubnet(var.cidr, 8, 6)
  ]

  enable_nat_gateway     = false
  single_nat_gateway     = false
  enable_dns_hostnames   = true
  one_nat_gateway_per_az = false

  # public_subnet_tags = {
  #   "kubernetes.io/cluster/${var.app_name}" = "shared"
  #   "kubernetes.io/role/elb"                      = 1
  # }

  # private_subnet_tags = {
  #   "kubernetes.io/cluster/${var.app_name}" = "shared"
  #   "kubernetes.io/role/internal-elb"             = 1
  # }
}

