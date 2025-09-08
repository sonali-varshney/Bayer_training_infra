resource "aws_vpc" "vpcdemo" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpcdemo"
  }
}

resource "aws_subnet" "pubsubnet" {
  vpc_id     = aws_vpc.vpcdemo.id
  count      = length(var.pub_cidr_block)                      #Note

  cidr_block = var.pub_cidr_block[count.index]                #Note
  availability_zone = var.pub_availability_zone[count.index]  #Note
  map_public_ip_on_launch = true   # to indicate that instances launched into the subnet should be assigned a public IP address
  
  tags = {
    Name = "publicsubnet-${var.pub_availability_zone[count.index]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpcdemo.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.vpcdemo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public route table"
  }
}


resource "aws_route_table_association" "associate_with_pub_subnet" {
  count          = length(var.pub_cidr_block)                             #NOTE
  subnet_id      = element(aws_subnet.pubsubnet[*].id, count.index)   #NOTE
  route_table_id = aws_route_table.pub_route_table.id
}


resource "aws_subnet" "prv_subnet" {
  vpc_id     = aws_vpc.vpcdemo.id
  count      = length(var.prv_cidr_block)                      #Note

  cidr_block = var.prv_cidr_block[count.index]                #Note
  availability_zone = var.prv_availability_zone[count.index]  #Note
  map_public_ip_on_launch = false   # to indicate that instances launched into the subnet should not be assigned a public IP address
  
  tags = {
    Name = "prvsubnet-${var.prv_availability_zone[count.index]}"
  }
}

resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.vpcdemo.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat.id
#   }

  tags = {
    Name = "private route table"
  }
}

resource "aws_route_table_association" "associate_with_prv_subnet" {
  count          = length(var.prv_cidr_block) 
  subnet_id      = element(aws_subnet.prv_subnet[*].id, count.index)
  route_table_id = aws_route_table.priv_route_table.id
}



#Create Subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main"
  subnet_ids =  [aws_subnet.prv_subnet[*].id]   #Note

  tags = {
    Name = "My DB subnet group"
  }
}

#Create MYSQL DB
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible  = false # Ensure RDS is not publicly accessible
}


resource "aws_security_group" "db_sec_gp" {
  name        = "db_sec_gp"
  description = "Allow TLS inbound traffic and all outbound traffic"
 # vpc_id      = aws_vpc.vpcdemo.id

  tags = {
    Name = "db_secgp"
  }

  # Allow SSH access from anywhere (you can restrict this to your IP)
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # You can change this to your IP for better security
 #security_groups = [aws_security_group.alb_sec_gp.id]  # Only allow traffic from the ALB's security group
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
