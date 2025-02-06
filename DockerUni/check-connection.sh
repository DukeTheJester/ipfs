#!/bin/bash
# list_peers.sh
# Lists the peers of every IPFS node in the network

# Define your nodes
NODES=("ipfs-node0" "ipfs-node1" "ipfs-node2" "ipfs-node3" "ipfs-node4" "ipfs-node5" "ipfs-node6" "ipfs-node7" "ipfs-node8" "ipfs-node9" "ipfs-node10" "ipfs-node11")

# Iterate over each node and output its peers
for node in "${NODES[@]}"; do
    echo "Node $node peers:"
    docker exec $node ipfs swarm peers
    echo ""
done

echo "Peer listing complete."