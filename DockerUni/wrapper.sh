#!/bin/bash

# Check for topology type argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <topology_type>"
  echo "Available topologies: ring, grid, complete, barabasi"
  exit 1
fi

TOPOLOGY=$1

# Run the appropriate topology script
case $TOPOLOGY in
  ring)
    ./connect_ring.sh
    ;;
  grid)
    ./connect_grid.sh
    ;;
  complete)
    ./connect_complete.sh
    ;;
  barabasi)
    ./connect_barabasi.sh
    ;;
  *)
    echo "Error: Unsupported topology type '$TOPOLOGY'."
    echo "Available topologies: ring, grid, complete, barabasi"
    exit 1
    ;;
esac