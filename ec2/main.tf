data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "ec2_dev"{

   ami                    = data.aws_ami.amazon_linux2.id
   #count                  = length(var.subnet_id)   # note
   instance_type          = var.instance_type
   #subnet_id              = var.subnet_id[count.index]  # note
   vpc_security_group_ids = [aws_security_group.ec2_sec_gp.id] #var.security_gp
   user_data              = file("nginx2.sh")  #Note
   tags = {
     Name                 = "myec2" #"ec2-${count.index + 1 }"
} 
}

 
 

resource "aws_security_group" "ec2_sec_gp" {
  name        = "ec2_sec_gp"
  description = "Allow TLS inbound traffic and all outbound traffic"
 # vpc_id      = aws_vpc.vpcdemo.id

  tags = {
    Name = "ec2_secgp"
  }

  # Allow SSH access from anywhere (you can restrict this to your IP)
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # You can change this to your IP for better security
  }

  # Allow HTTP (port 80) traffic ONLY from the load balancer's security group
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

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