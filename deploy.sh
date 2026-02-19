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

# Create ACME challenge directory
sudo mkdir -p /var/www/html/.well-known/acme-challenge
sudo chown -R www-data:www-data /var/www/html

# Start/reload nginx with HTTP-only config first
sudo systemctl restart nginx || sudo systemctl start nginx

# Install certbot if not installed
if ! command -v certbot &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
fi

# Get SSL certificate
# Using DNS validation because Cloudflare is proxying (HTTP validation won't work)
echo "=========================================="
echo "SSL Certificate Setup"
echo "=========================================="
echo "Since Cloudflare is proxying your domain, we need DNS validation."
echo "Run this command manually and follow the prompts:"
echo ""
echo "sudo certbot certonly --manual --preferred-challenges dns -d luviadental.com -d www.luviadental.com"
echo ""
echo "After getting the certificate, run:"
echo "sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --redirect"
echo ""
read -p "Have you already obtained SSL certificates? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Certificates exist, just configure nginx
    sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --redirect
else
    echo "Please obtain certificates first using DNS validation, then run this script again."
    exit 1
fi

# Reload nginx after SSL setup
sudo systemctl reload nginx

echo "Deployment complete! Site should be available at https://luviadental.com"
