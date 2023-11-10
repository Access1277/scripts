#!/bin/bash

# Your DNS resolver's IP addresses
DNS_RESOLVERS=("127.0.0.1")

# Domain records to query
DOMAINS=("myudp.elcavlaw.com" "sdns.myudp.elcavlaw.com" "mamawers.elcavlaw.com" "team-mamawers.elcavlaw.com")

# Set the number of parallel queries
NUM_PARALLEL_QUERIES=2

# Loop delay in seconds
LOOP_DELAY=5

# Function to perform DNS queries
query_dns() {
  local resolver="$1"
  local domain="$2"
  
  result=$(dig +short @"$resolver" "$domain" 2>/dev/null)
  if [ $? -eq 0 ] && [ -n "$result" ]; then
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
      {
        query_dns "$resolver" "$domain"
      } &
      
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
