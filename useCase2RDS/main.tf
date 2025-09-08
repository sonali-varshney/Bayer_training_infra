module "ec2"{
    source = "./ec2/"
    subnet_id = module.vpc.pubsubnet


}

module "vpc"{
    source = "./vpc/"
    subnet_id = 

}