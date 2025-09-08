outputs "pubsubnet"{
    value = aws_subnet.pubsubnet[*].id
}