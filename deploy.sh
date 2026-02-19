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

# SSL setup (optional)
echo "=========================================="
echo "SSL Certificate Setup (Optional)"
echo "=========================================="
read -p "Do you want to set up SSL now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Check if certificates already exist
    if [ -f "/etc/letsencrypt/live/luviadental.com/fullchain.pem" ]; then
        echo "Certificates found. Configuring nginx with SSL..."
        sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --redirect
    else
        echo "No certificates found. You can set up SSL later using:"
        echo "  sudo certbot certonly --manual --preferred-challenges dns -d luviadental.com -d www.luviadental.com"
        echo "  sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --redirect"
        echo ""
        echo "Skipping SSL setup for now. Site will run on HTTP."
    fi
else
    echo "Skipping SSL setup. Site will run on HTTP."
    echo "To add SSL later, run:"
    echo "  sudo certbot certonly --manual --preferred-challenges dns -d luviadental.com -d www.luviadental.com"
    echo "  sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --redirect"
fi

# Reload nginx
sudo systemctl reload nginx

echo ""
echo "=========================================="
echo "Deployment complete!"
echo "Site is available at: http://luviadental.com"
echo "To add SSL later, see instructions above."
echo "=========================================="
