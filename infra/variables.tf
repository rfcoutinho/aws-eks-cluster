variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "challenge"
}

