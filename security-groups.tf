# Reference To avoid "cycle error" see this https://stackoverflow.com/questions/38246326/cycle-error-when-trying-to-create-aws-vpc-security-groups-using-terraform

resource "aws_security_group" "eks-cluster-sg" {
  name        = "eks-cluster-sg"
  description = "Principle of least privilege applied to the cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "TLS from node security group"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = aws_security_group.eks-nodes-sg.id
  }

  egress {
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = aws_security_group.eks-nodes-sg.id
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_security_group" "eks-nodes-sg" {
  name        = "eks-nodes-sg"
  description = "Principle of least privilege applied to the nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "TCP communication from control plane"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = aws_security_group.eks-cluster-sg.id
  }

  egress {
    description     = "Allow TLS to control plane"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = aws_security_group.eks-cluster-sg.id
  }

  tags = {
    Name = "eks-nodes-sg"
  }
}

resource "aws_security_group_rule" "eks-nodes-to-contro-plane" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = "${aws_security_group.bastion.id}"
    source_security_group_id = "${aws_security_group.private.id}"
}