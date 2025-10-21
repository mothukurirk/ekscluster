provider "aws" {
  region = "us-east-1"
}

# --- VPC ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
  }
}

# --- EKS Cluster ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.0"

  name               = "eks-cluster"
  kubernetes_version = "1.30"
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

    cluster_auth = {
    manage_aws_auth_configmap = true

    aws_auth_roles = [
      {
        rolearn  = "arn:aws:iam::735546544739:role/JenkinsEC2"
        username = "JenkinsEC2"
        groups   = ["system:masters"]
      }
    ]

    aws_auth_users = [
      {
        userarn  = "arn:aws:iam::735546544739:user/radhakrishna"
        username = "radhakrishna"
        groups   = ["system:masters"]
      }
    ]
  }


  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
