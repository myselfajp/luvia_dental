#!/bin/bash

echo "=========================================="
echo "Checking DNS TXT Record"
echo "=========================================="
echo ""
echo "Checking if _acme-challenge.luviadental.com TXT record exists..."
echo ""

# Check DNS TXT record
nslookup -type=TXT _acme-challenge.luviadental.com

echo ""
echo "=========================================="
echo "If you see the TXT record above, DNS is propagated."
echo "If not, make sure you added it in Cloudflare:"
echo ""
echo "1. Go to Cloudflare Dashboard → DNS → Records"
echo "2. Add record:"
echo "   Type: TXT"
echo "   Name: _acme-challenge"
echo "   Content: [the value certbot showed]"
echo "   TTL: Auto"
echo "3. Save and wait 1-2 minutes"
echo "=========================================="
