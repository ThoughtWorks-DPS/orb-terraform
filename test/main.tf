module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.instance_name}-vpc"
  cidr = var.vpc_cidr
  azs  = var.vpc_azs

  # private, node subnet
  private_subnets       = var.vpc_private_subnets
  private_subnet_suffix = "private-subnet"
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.instance_name}" = "shared"
    "Tier"                                       = "node"
  }

  # public ingress subnet
  public_subnets       = var.vpc_public_subnets
  public_subnet_suffix = "public-subnet"
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.instance_name}" = "shared"
    "kubernetes.io/role/elb"                     = "1"
    "Tier"                                       = "public"
  }

  database_subnets       = var.vpc_database_subnets
  database_subnet_suffix = "database-subnet"
  database_subnet_tags = {
    "Tier" = "database"
  }

  create_database_subnet_group    = true
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  map_public_ip_on_launch = false
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
}