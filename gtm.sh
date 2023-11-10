#!/bin/bash
# Copyright © 2023 YourName
# DNS Keep-Alive script for DNSTT server NS record queries

# DNSTT Nameservers and Domain `NS` Records
DNS_SERVERS=('sdns.myudp.elcavlaw.com' 'team-mamawers.elcavlaw.com')


# Number of parallel queries for each resolver and domain
PARALLEL_QUERIES=5

# Repeat dig command loop time (seconds)
LOOP_DELAY=2

# Add your DNS resolver IPs here
RESOLVERS=('112.198.115.44' '124.6.181.20')

# Function to perform DNS NS record queries
query_ns_records() {
  local resolver="$1"
  local domain="$2"
  result=$(dig +short +stats +tries=1 +timeout=1 NS "@${resolver}" "${domain}" 2>/dev/null || echo 'Query failed')
  echo "Resolver: ${resolver}, Domain: ${domain}, NS Records: ${result}"
}

# Main loop
while true; do
  for resolver in "${RESOLVERS[@]}"; do
    for domain in "${DOMAINS[@]}"; do
      # Run NS record queries in parallel for better speed
      (
        for ((i=0; i<PARALLEL_QUERIES; i++)); do
          query_ns_records "${resolver}" "${domain}"
        done
      ) &
    done
  done

  # Wait for all parallel queries to complete
  wait

  # Sleep before the next iteration
  sleep "${LOOP_DELAY}"
done
