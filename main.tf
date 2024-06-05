module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source           = "./modules/eks"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.subnet_ids
  cluster_name     = var.cluster_name
}

module "s3" {
  source = "./modules/s3"
  bucket_name = "upay-front"
}

module "cloudfront" {
  source = "./modules/cloudfront"
  domain_name = module.s3.bucket_regional_domain_name
  bucket_name = module.s3.bucket_name
  region = var.region
}
