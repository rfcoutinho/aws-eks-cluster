module "eks" {
  source                        = "terraform-aws-modules/eks/aws"
  cluster_name                  = var.cluster_name
  cluster_version               = "1.19"
  subnets                       = module.vpc.private_subnets
  cluster_security_group_id     = aws_security_group.eks-cluster-sg.id
  cluster_create_security_group = false
  cluster_iam_role_name         = aws_iam_role.eks_cluster_role.name
  manage_cluster_iam_resources  = false

  worker_create_security_group = false
  worker_security_group_id     = aws_security_group.eks-nodes-sg.id

  write_kubeconfig = true

  tags = {
    Environment = "challenge"
    GithubRepo  = "aws-eks-cluster"
    GithubOrg   = "rfcoutinho"
  }

  vpc_id = module.vpc.vpc_id
  
  depends_on = [
    aws_iam_role.eks_cluster_role,
  ]

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "aws_eks_node_group" "node-group-1" {
  cluster_name    = var.cluster_name
  node_group_name = "node-group-1"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.vpc.private_subnets

  instance_types = ["t3a.small", "t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    module.eks.cluster_id,
  ]
}
