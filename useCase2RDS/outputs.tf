output "pubsubnet"{
    value = module.vpc.pubsubnet[*].id
}