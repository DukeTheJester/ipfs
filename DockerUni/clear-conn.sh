#!/bin/bash

# First, clear existing connections
for i in {0..11}; do
    echo "Node $i"
    docker exec ipfs-node$i ipfs swarm peers | xargs -I {} docker exec ipfs-node$i ipfs swarm disconnect {}
done
