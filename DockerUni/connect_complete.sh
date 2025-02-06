#!/bin/bash

# Connect nodes in a complete graph
for i in {0..10}; do
  for j in $(seq $((i+1)) 11); do
    docker exec ipfs-node$i ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node$j)/tcp/4001/ipfs/$(docker exec ipfs-node$j ipfs id -f "<id>")
  done
done