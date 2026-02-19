#!/bin/bash

# Update nginx config path
read -p "Enter full path to project directory: " PROJECT_PATH

sed -i "s|/path/to/luvia|$PROJECT_PATH|g" nginx.conf
DOMAIN="luviadental.com"

# Copy nginx config
sudo cp nginx.conf /etc/nginx/sites-available/luvia
sudo ln -sf /etc/nginx/sites-available/luvia /etc/nginx/sites-enabled/

# Test nginx config
sudo nginx -t

# Install certbot if not installed
if ! command -v certbot &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
fi

# Get SSL certificate
sudo certbot --nginx -d luviadental.com -d www.luviadental.com

# Reload nginx
sudo systemctl reload nginx

echo "Deployment complete! Site should be available at https://luviadental.com"
