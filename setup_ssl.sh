#!/bin/bash

echo "=========================================="
echo "SSL Certificate Setup"
echo "=========================================="
echo ""
echo "Since Cloudflare is proxying your domain, we'll use DNS validation."
echo ""

# Check if certificates already exist
if [ -f "/etc/letsencrypt/live/luviadental.com/fullchain.pem" ]; then
    echo "Certificates already exist. Configuring nginx..."
    sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --redirect
    sudo systemctl reload nginx
    echo ""
    echo "✓ SSL configured! Site should be available at https://luviadental.com"
    exit 0
fi

echo "Step 1: Obtaining certificate using DNS validation..."
echo "You'll need to add a TXT record to your Cloudflare DNS."
echo ""
sudo certbot certonly --manual --preferred-challenges dns -d luviadental.com -d www.luviadental.com

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Certificate obtained!"
    echo ""
    echo "Step 2: Configuring nginx with SSL..."
    sudo certbot --nginx -d luviadental.com -d www.luviadental.com --non-interactive --redirect
    sudo systemctl reload nginx
    echo ""
    echo "=========================================="
    echo "✓ SSL setup complete!"
    echo "Site is now available at: https://luviadental.com"
    echo "=========================================="
else
    echo ""
    echo "✗ Certificate setup failed. Please try again."
    exit 1
fi
