#!/bin/bash

# Update nginx config path
PROJECT_PATH="/home/luvia_dental"

sed -i "s|/path/to/luvia|$PROJECT_PATH|g" nginx.conf 2>/dev/null || true
DOMAIN="luviadental.com"

# Copy nginx config
sudo cp nginx.conf /etc/nginx/sites-available/luvia
sudo ln -sf /etc/nginx/sites-available/luvia /etc/nginx/sites-enabled/

# Remove default nginx site if it exists
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx config
sudo nginx -t

# Start/reload nginx with HTTP-only config first
sudo systemctl restart nginx || sudo systemctl start nginx

# Install certbot if not installed
if ! command -v certbot &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
fi

# Get SSL certificate (certbot will automatically modify nginx config)
sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --agree-tos --redirect

# Reload nginx after SSL setup
sudo systemctl reload nginx

echo "Deployment complete! Site should be available at https://luviadental.com"
