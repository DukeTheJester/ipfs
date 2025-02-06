# Information

StandardIPFS contains only the innermost kubo-master directory of the original ipfs download with the changes we made. In addition you will find config.json there.

DockerUni contains the Implementation with Docker. Do note, that we tested and used this within github codespaces.

# Important Files
### StandardIPFS

discovery.go:   we made changes here

config.json:    we made changes here

### DockerUni

docker-compose.yml: our .yml file for docker-compose

sim.sh:             script, simulating the upload and download of files

connect_ring:       creates ring topology

connect_grid:       creates grid topology

connect_complete:   creates complete graph topology

connect_barabasi:   creates BA topology

clear-conn.sh:      clears all existing connections