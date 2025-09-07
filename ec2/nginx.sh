#!/bin/bash
# Update system
yum update -y

# Install nginx (Amazon Linux 2 uses amazon-linux-extras)
amazon-linux-extras install -y nginx1

# Enable & start nginx
systemctl enable nginx
systemctl start nginx

# Create custom content under /usr/share/nginx/html/images
mkdir -p /usr/share/nginx/html/images
echo "<h1>Hello Images!</h1>" > /usr/share/nginx/html/images/index.html

# Configure nginx
cat << 'EOF' > /etc/nginx/conf.d/images.conf
server {
    listen 80;
    server_name _;

    # Default root
    root /usr/share/nginx/html;
    index index.html;

    # /images path
    location /images/ {
        alias /usr/share/nginx/html/images/;
        index index.html;
    }
}
EOF

# Restart nginx to apply config
systemctl restart nginx
