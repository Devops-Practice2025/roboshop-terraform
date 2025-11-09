## VPC module
module "vpc" {
  source = "./modules/vpc"

  cidr               = var.vpc["cidr"]
  env                = var.env
  public_subnets     = var.vpc["public_subnets"]
  #app_subnets        = var.vpc["app_subnets"]
  web_subnets        = var.vpc["web_subnets"]
  #db_subnets         = var.vpc["db_subnets"]
  availability_zones = var.vpc["availability_zones"]
  default_cidr       = var.vpc["default_cidr"]
  default_subnets    = var.vpc["default_subnets"]
   
}

module "ec2" {
    depends_on = [ module.vpc]
  source = "./modules/ec2"

  for_each      = var.ec2
  name          = each.key
  instance_type = each.value["instance_type"]
  allow_port    = each.value["app_port"]
  allow_sg_cidr = each.value["app_sg_cidr"]
  subnet_ids    = module.vpc.subnets[each.value["subnet_ref"]]
  vpc_id        = module.vpc.vpc_id
  env           = var.env
  bastion_nodes = var.bastion_nodes
  asg = true


}
