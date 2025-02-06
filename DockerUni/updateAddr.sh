#!/bin/bash

# Docker container prefix for IPFS nodes
CONTAINER_PREFIX="ipfs-node"

# Function to get the internal IP address of a Docker container
get_container_ip() {
  local container_name=$1
  # Get the IP address of the container within Docker's bridge network
  docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_name"
}

# Function to update IPFS config with the correct addresses
update_ipfs_config() {
  local container_name=$1
  local ip_address=$2

  # Update the Swarm, API, and Gateway addresses
  docker exec "$container_name" ipfs config --json Addresses.Swarm "[\"/ip4/$ip_address/tcp/4001\", \"/ip6/::/tcp/4001\"]"
  docker exec "$container_name" ipfs config --json Addresses.NoAnnounce "[\"/ip4/$ip_address/tcp/4001\", \"/ip6/::/tcp/4001\"]"
  docker exec "$container_name" ipfs config --json Addresses.API "\"/ip4/$ip_address/tcp/5001\""
  docker exec "$container_name" ipfs config --json Addresses.Gateway "\"/ip4/$ip_address/tcp/8080\""
}

# Loop over each node and update its configuration
for i in {0..11}; do
  container_name="${CONTAINER_PREFIX}${i}"
  
  # Get the internal IP address for the current node
  node_ip=$(get_container_ip "$container_name")
  
  # Check if the IP address was found
  if [ -z "$node_ip" ]; then
    echo "Error: Could not retrieve IP address for $container_name"
    continue
  fi
  
  echo "Updating IPFS config for $container_name with IP: $node_ip"
  
  # Update the configuration with the new IP address
  update_ipfs_config "$container_name" "$node_ip"
  
  echo "Configuration updated for $container_name"
done

echo "All IPFS nodes updated successfully!"