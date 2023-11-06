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
}

resource "aws_eip" "nagios" {
  depends_on = [
    module.vpc,
    aws_instance.nagios
  ]

  instance = aws_instance.nagios.id
  domain = "vpc"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = file("./certs/ec2_key.pub")
}

resource "aws_instance" "nagios" {
  depends_on = [
    aws_security_group.allow_nagios,
    aws_key_pair.ec2_key,
    module.vpc
  ]

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = ["${aws_security_group.allow_nagios.id}"]
  key_name               = aws_key_pair.ec2_key.key_name
  tags = {
    Name = "nagios"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "allow_nagios" {
  name        = "allow_nagios"
  description = "Allow nagios access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}