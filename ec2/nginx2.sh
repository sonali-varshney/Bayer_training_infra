#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

mkdir -p /var/www/html/images
echo "<h1>Hello Images!</h1>" > /var/www/html/images/index.html
