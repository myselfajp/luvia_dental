#!/bin/bash

echo "=========================================="
echo "Server Status Check"
echo "=========================================="

# Check if nginx is running
echo "1. Checking nginx status..."
sudo systemctl status nginx --no-pager | head -5

# Check if nginx is listening on port 80
echo ""
echo "2. Checking if nginx is listening on port 80..."
sudo netstat -tlnp | grep :80 || sudo ss -tlnp | grep :80

# Check nginx config
echo ""
echo "3. Testing nginx configuration..."
sudo nginx -t

# Check if site config exists
echo ""
echo "4. Checking nginx site configuration..."
ls -la /etc/nginx/sites-enabled/luvia

# Check server IP
echo ""
echo "5. Server IP addresses:"
ip addr show | grep "inet " | grep -v 127.0.0.1

# Check firewall status
echo ""
echo "6. Checking firewall status..."
if command -v ufw &> /dev/null; then
    sudo ufw status
elif command -v firewall-cmd &> /dev/null; then
    sudo firewall-cmd --list-all
else
    echo "No common firewall tool found"
fi

echo ""
echo "=========================================="
echo "Next steps:"
echo "1. Make sure nginx is running: sudo systemctl start nginx"
echo "2. Make sure port 80 is open in firewall"
echo "3. In Cloudflare DNS, make sure A record points to your server IP"
echo "4. If using Cloudflare proxy, ensure server allows Cloudflare IPs"
echo "=========================================="
