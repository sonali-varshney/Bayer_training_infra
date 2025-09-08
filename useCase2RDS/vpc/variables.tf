variable "pub_cidr_block"{
    type = list
    default = ["10.0.0.0/24","10.0.1.0/24"]
}

variable "prv_cidr_block"{
    type = list
    default = ["10.0.2.0/24","10.0.3.0/24"]
}

variable "pub_availability_zone"{
    type = list
    default = ["us-east-1a","us-east-1b"]
}

variable "prv_availability_zone"{
    type = list
    default = ["us-east-1c","us-east-1d"]
}

