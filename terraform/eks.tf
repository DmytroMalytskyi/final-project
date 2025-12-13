module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = var.cluster_version

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.public_subnets
  enable_irsa                    = true
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = var.desired_size
      min_size       = var.min_size
      max_size       = var.max_size
      subnet_ids     = module.vpc.public_subnets
      ami_type       = "AL2_x86_64"
    }
  }

  tags = { Project = var.project_name }
}

# kubeconfig для локальних утиліт (опційно як output)
