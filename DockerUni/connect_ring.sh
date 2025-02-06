#!/bin/bash


docker exec ipfs-node0 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node11)/tcp/4001/ipfs/$(docker exec ipfs-node11 ipfs id -f "<id>")
docker exec ipfs-node1 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node0)/tcp/4001/ipfs/$(docker exec ipfs-node0 ipfs id -f "<id>")
docker exec ipfs-node2 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node1)/tcp/4001/ipfs/$(docker exec ipfs-node1 ipfs id -f "<id>")
docker exec ipfs-node3 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node2)/tcp/4001/ipfs/$(docker exec ipfs-node2 ipfs id -f "<id>")
docker exec ipfs-node4 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node3)/tcp/4001/ipfs/$(docker exec ipfs-node3 ipfs id -f "<id>")
docker exec ipfs-node5 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node4)/tcp/4001/ipfs/$(docker exec ipfs-node4 ipfs id -f "<id>")
docker exec ipfs-node6 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node5)/tcp/4001/ipfs/$(docker exec ipfs-node5 ipfs id -f "<id>")
docker exec ipfs-node7 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node6)/tcp/4001/ipfs/$(docker exec ipfs-node6 ipfs id -f "<id>")
docker exec ipfs-node8 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node7)/tcp/4001/ipfs/$(docker exec ipfs-node7 ipfs id -f "<id>")
docker exec ipfs-node9 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node8)/tcp/4001/ipfs/$(docker exec ipfs-node8 ipfs id -f "<id>")
docker exec ipfs-node10 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node9)/tcp/4001/ipfs/$(docker exec ipfs-node9 ipfs id -f "<id>")
docker exec ipfs-node11 ipfs swarm connect /ip4/$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs-node10)/tcp/4001/ipfs/$(docker exec ipfs-node10 ipfs id -f "<id>")