
sudo yum update -y
sudo yum install epel-release -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

 # Create custom content
mkdir -p /usr/share/nginx/html/images
echo "<h1>Hello Images!</h1>" > /usr/share/nginx/html/images/index.html

      
# Create a new Nginx configuration file for the /images path
# Using a custom conf.d file is a best practice
cat << 'EOF' | sudo tee /etc/nginx/conf.d/images.conf
server {
    listen 80;
    server_name _;

    # Default website content
    location / {
        root /var/www/html;
        index index.html;
    }

    # Configuration for the /images path
    location /images/ {
        # 'alias' maps the URI path to a specific filesystem path
        alias /usr/share/nginx/images/;
    }
}
EOF



# Restart Nginx to apply the new configuration
sudo systemctl restart nginx



