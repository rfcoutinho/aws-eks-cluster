terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.22"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.11"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.1.0"
    }
  }
}