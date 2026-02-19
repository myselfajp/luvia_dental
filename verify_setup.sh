#!/bin/bash

echo "=========================================="
echo "Verifying Setup"
echo "=========================================="

# Check if HTML file exists
echo "1. Checking if luvia.html exists..."
if [ -f "/home/luvia_dental/luvia.html" ]; then
    echo "✓ File exists: /home/luvia_dental/luvia.html"
    ls -lh /home/luvia_dental/luvia.html
else
    echo "✗ File NOT found: /home/luvia_dental/luvia.html"
    echo "  Current directory contents:"
    ls -la /home/luvia_dental/
fi

# Check nginx root directory permissions
echo ""
echo "2. Checking directory permissions..."
ls -ld /home/luvia_dental

# Test nginx can serve the file
echo ""
echo "3. Testing local HTTP request..."
curl -I http://localhost/ 2>&1 | head -10

# Check server IP
echo ""
echo "4. Server public IP:"
echo "   46.225.185.148"
echo ""
echo "=========================================="
echo "Cloudflare DNS Check:"
echo "=========================================="
echo "Make sure in Cloudflare Dashboard → DNS:"
echo "  - A record: luviadental.com → 46.225.185.148 (Proxied)"
echo "  - A record: www.luviadental.com → 46.225.185.148 (Proxied)"
echo ""
echo "Test direct access (bypass Cloudflare):"
echo "  curl -I http://46.225.185.148/"
echo "=========================================="
