#!/bin/bash

# Your DNS resolver's IP addresses (e.g., Google DNS and Cloudflare DNS)
DNS_RESOLVERS=("112.198.115.44" "112.198.115.36" "124.6.181.20" "124.6.181.36")

# Domain records to query
DOMAINS=("myudp.elcavlaw.com" "sdns.myudp.elcavlaw.com" "mamawers.elcavlaw.com" "team-mamawers.elcavlaw.com")

# Set the number of parallel queries (adjust based on your system's capabilities)
NUM_PARALLEL_QUERIES=4

# Loop delay in seconds (adjust as needed)
LOOP_DELAY=5

# Function to perform DNS queries
query_dns() {
  local resolver="$1"
  local domain="$2"
  
  if result=$(dig +short @"$resolver" "$domain" 2>/dev/null); then
    echo "Resolver: $resolver, Domain: $domain, Result: $result"
  else
    echo "Resolver: $resolver, Domain: $domain, Result: Query failed"
  fi
}

# Main loop
while true; do
  for resolver in "${DNS_RESOLVERS[@]}"; do
    for domain in "${DOMAINS[@]}"; do
      # Run queries in parallel for better speed
      (
        query_dns "$resolver" "$domain"
      ) &
      
      # Control the number of parallel queries
      if [[ $(jobs -p | wc -l) -ge $NUM_PARALLEL_QUERIES ]]; then
        wait
      fi
    done
  done
  
  # Wait for all parallel queries to complete
  wait
  
  # Sleep before the next iteration
  sleep $LOOP_DELAY
done
