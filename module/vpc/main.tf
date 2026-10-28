module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project}-${var.env}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
  create_database_subnet_group = true

  public_subnet_tags = {
    
    "kubernetes.io/role/elb"                      = "1" # Allows internet-facing K8s LoadBalancers
  }
   private_subnet_tags = {
    "kubernetes.io/cluster/${var.project}-${var.env}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1" # Allows internal K8s LoadBalancers
  }
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
