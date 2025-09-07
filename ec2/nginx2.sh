#!/bin/bash
# Update system
dnf update -y

# Install nginx (Amazon Linux 2023 uses dnf)
dnf install -y nginx

# Enable & start nginx
systemctl enable nginx
systemctl start nginx

# Create /images content
mkdir -p /usr/share/nginx/html/images
echo "<h1>Hello Images!</h1>" > /usr/share/nginx/html/images/index.html
