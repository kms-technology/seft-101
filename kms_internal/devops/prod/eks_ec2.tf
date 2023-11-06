# module "eks" {
#   source = "terraform-aws-modules/eks/aws"
#   version = "${var.module_version}"

#   depends_on = [ module.vpc ]

#   cluster_name = var.app_name
#   cluster_version = var.eks_version
#   vpc_id = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   eks_managed_node_group_defaults = {
#     ami_type = var.ami_type
#   }

#   eks_managed_node_groups = {
#     initial = {
#         name = "${var.app_name}-ngroup"
#         instance_type = ["${var.instance_type}"]

#         min_size = 1
#         max_size = 3
#         desired_size = 2

#         vpc_security_group_ids = [
#             aws_security_group.node_group.id
#         ]
#     }
#   }
# }

# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version = "4.7.0"

#   create_role                   = true
#   role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
#   provider_url                  = module.eks.oidc_provider
#   role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
# }

# resource "aws_eks_addon" "ebs-csi" {
#   cluster_name             = module.eks.cluster_name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.20.0-eksbuild.1"
#   service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#   tags = {
#     "eks_addon" = "ebs-csi"
#     "terraform" = "true"
#   }
# }

resource "aws_eip" "nagios" {
  depends_on = [
    module.vpc,
    aws_instance.nagios
  ]

  instance = aws_instance.nagios.id
  domain   = "vpc"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = file("./certs/ec2_key.pub")
}

resource "aws_instance" "nagios" {
  depends_on = [
    aws_security_group.nagios,
    aws_key_pair.ec2_key,
    module.vpc
  ]

  ami                    = var.ami_type
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = ["${aws_security_group.nagios.id}"]
  # user_data              = file("../scripts/nagios.sh")
  # user_data_replace_on_change = true
  key_name = aws_key_pair.ec2_key.key_name
  tags = {
    Name = "nagios-${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}