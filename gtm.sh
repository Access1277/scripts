#!/bin/bash

# Your DNS resolver's IP addresses (e.g., Google DNS and Cloudflare DNS)
DNS_RESOLVERS=("112.198.115.44" "112.198.115.36" "124.6.181.20" "124.6.181.36")

# Domain records to query
DOMAINS=("myudp.elcavlaw.com" "sdns.myudp.elcavlaw.com" "mamawers.elcavlaw.com" "team-mamawers.elcavlaw.com")

# Function to perform a single DNS query
query_dns() {
  resolver="$1"
  domain="$2"
  result=$(dig +short @"$resolver" "$domain" 2>/dev/null)
  if [ -n "$result" ]; then
    echo "Resolver: $resolver, Domain: $domain, Result: $result"
  fi
}

# Export the function so it can be used by parallel
export -f query_dns

# Perform parallel DNS queries for all resolvers and domains
parallel -j 0 query_dns ::: "${DNS_RESOLVERS[@]}" ::: "${DOMAINS[@]}"
