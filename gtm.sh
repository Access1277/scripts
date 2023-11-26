#!/bin/bash

# Check if dnsutils is installed
if ! command -v dig &> /dev/null; then
    echo "dnsutils is not installed. Installing..."
    pkg install dnsutils -y
fi

# Specify the domain and IP
domain="sdns.myudph.elcavlaw.com"
ip=$(dig +short $domain)

# Replace the dynamically obtained IP with the specific IP address
ip="124.6.181.12"

# Display the IP address
if [ -z "$ip" ]; then
    echo "No IP address found for $domain."
else
    echo "IP address for $domain: $ip"
fi
