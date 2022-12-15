module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  cluster_name              = var.cluster_name
  cluster_version           = "1.24"
  cluster_security_group_id = aws_security_group.eks-cluster-sg.id

  # aws-auth configmap
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  tags = {
    Environment = "challenge"
    GithubRepo  = "aws-eks-cluster"
    GithubOrg   = "rfcoutinho"
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  depends_on = [
    aws_iam_role.eks_cluster_role,
  ]

}

#Commented due the several opened issues to add a custom security group to eks managed nodes
#https:github.com/aws/containers-roadmap/issues/609
resource "aws_eks_node_group" "node-group-1" {
  cluster_name    = var.cluster_name
  node_group_name = "node-group-1"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.vpc.private_subnets

  instance_types = ["t3a.small", "t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    module.eks.cluster_id,
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
