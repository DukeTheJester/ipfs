#!/bin/bash

# Disable MDNS and Auto Connection
for i in {0..11}; do
  docker exec ipfs-node$i ipfs config --json AutoNAT.Enabled false
  docker exec ipfs-node$i ipfs config --json Discovery.MDNS.Enabled false
  docker exec ipfs-node$i ipfs config --json Swarm.DisableNatPortMap true
  docker exec ipfs-node$i ipfs config --json Swarm.ConnMgr.LowWater 0
  docker exec ipfs-node$i ipfs config --json Swarm.ConnMgr.HighWater 0
  docker exec ipfs-node$i ipfs config --json Swarm.ConnMgr.GracePeriod 0
  docker exec ipfs-node$i ipfs config --json Swarm.AutoConnect false
  docker exec ipfs-node$i ipfs config --json Swarm.EnableAutoNATService false
  docker exec ipfs-node$i ipfs config --json Addresses.NoAnnounce '["/ip4/0.0.0.0/tcp/4001", "/ip6/::/tcp/4001"]'
  docker exec ipfs-node$i ipfs config --json Routing.DHT false
  docker exec ipfs-node$i ipfs config --json Swarm.PeerExchange false
  docker exec ipfs-node$i ipfs bootstrap rm --all
  docker exec ipfs-node$i ipfs repo gc
done

docker restart $(docker ps -q --filter "name=ipfs-node")