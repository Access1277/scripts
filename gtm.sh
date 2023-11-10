#!/bin/bash
# Copyright © 2023 YourName
# DNS Keep-Alive script for DNSTT server domain record queries

# DNSTT Nameservers and Domain `A` Records
DNS_SERVERS=('sdns.myudp.elcavlaw.com' 'team-mamawers.elcavlaw.com')
DOMAINS=('myudp.elcavlaw.com' 'mamawers.elcavlaw.com')

# Repeat dig command loop time (seconds)
LOOP_DELAY=2

# Add your DNS resolver IPs here
RESOLVERS=('124.6.181.2' '124.6.181.36' '112.198.115.44' '112.198.115.36')

# Function to perform DNS queries
query_dns() {
  local resolver="$1"
  local domain="$2"
  result=$(dig +short +stats +tries=1 +timeout=1 "@${resolver}" "${domain}" 2>/dev/null || echo 'Query failed')
  echo "Resolver: ${resolver}, Domain: ${domain}, Result: ${result}"
}

# Main loop
while true; do
  for resolver in "${RESOLVERS[@]}"; do
    for domain in "${DOMAINS[@]}"; do
      # Run queries in parallel for better speed
      (
        query_dns "${resolver}" "${domain}"
      ) &
    done
  done
  
  # Wait for all parallel queries to complete
  wait
  
  # Sleep before the next iteration
  sleep "${LOOP_DELAY}"
done
