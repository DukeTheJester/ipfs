#!/bin/bash

# Start with two nodes (ipfs-node0 and ipfs-node1)
docker exec ipfs-node1 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node0)/tcp/4001/ipfs/$(docker exec ipfs-node0 ipfs id -f "<id>")

# Connect subsequent nodes preferentially (attach 2 new nodes to existing nodes with higher degrees)
for i in {2..11}; do
  # Preferably attach to ipfs-node0 and ipfs-node1 (just an example for simplicity, you can modify logic for actual preferential attachment)
  docker exec ipfs-node$i ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node0)/tcp/4001/ipfs/$(docker exec ipfs-node0 ipfs id -f "<id>")
  docker exec ipfs-node$i ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node1)/tcp/4001/ipfs/$(docker exec ipfs-node1 ipfs id -f "<id>")
done