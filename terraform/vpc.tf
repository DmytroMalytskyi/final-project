module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = "${var.project_name}-vpc"
  cidr = "10.50.0.0/16"

  # Availability Zones
  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  # Public subnets (for EKS nodes + LoadBalancers)
  public_subnets = [
    "10.50.1.0/24",
    "10.50.2.0/24"
  ]

  # IMPORTANT: public IP for EKS worker nodes
  map_public_ip_on_launch = true

  # Networking options
  enable_nat_gateway     = false
  single_nat_gateway     = false
  enable_dns_support     = true
  enable_dns_hostnames   = true

  # Tags required for EKS / LoadBalancers
  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
  }
}
