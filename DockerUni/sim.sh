#!/bin/bash

# Configuration
LOG_DIR="simulation_logs"
METRICS_FILE="$LOG_DIR/all_metrics.csv"
SIMULATION_DURATION=150
INTERVAL=30  # Time between operations

#
# Create log directory
mkdir -p $LOG_DIR

# Initialize metrics file with header
echo "Topology,FileSize(MB),UploadTime(s),DownloadTime(s),CPU(%),Memory(MB),TotalUpload(MB),TotalDownload(MB),UploadBandwidth(Mbps),DownloadBandwidth(Mbps)" > $METRICS_FILE

# Function to measure Docker container metrics
get_metrics() {
    local container=$1
    local stats=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}}" $container)
    local cpu=$(echo $stats | cut -d',' -f1 | tr -d '%')
    local memory=$(echo $stats | cut -d',' -f2 | awk '{print $1}')
    echo "$cpu,$memory"
}

# Function to run simulation for a specific topology
run_simulation() {
    local topology=$1
    local connect_script="connect_${topology}.sh"
    
    echo "Starting simulation for $topology topology"
    
    # Clear existing connections and setup new topology
    ./clear-conn.sh
    ./$connect_script
    
    # Wait for network to stabilize
    sleep 30
    
    # Get list of containers
    containers=$(docker ps --format "{{.Names}}" | grep "ipfs-node")
    
    # Iterate over each test file
    for file in TestFiles/*.bin; do
        filename=$(basename $file)
        file_size_bytes=$(stat -c '%s' "$file")  # Get file size in bytes
        file_size_mb=$(echo "scale=2; $file_size_bytes / 1048576" | bc) # File size in MB
        
        # Randomly select one uploading container
        upload_container=$(echo "$containers" | shuf -n 1)
        
        # Randomly select a different downloading container
        target_containers=$(echo "$containers" | grep -v "$upload_container" | shuf)
        
        #break after first 3 downloads
        counter=0

        for container in $target_containers; do
            if (( counter >= 3 )); then
                break
            fi
            
            # Copy file into container
            docker cp "$file" "$upload_container:/root/$filename"
            
            # Upload file
            echo "[$topology] $upload_container uploading $filename"
            start_upload=$(date +%s.%N)
            upload_output=$(docker exec $upload_container ipfs add -q "/root/$filename" 2>&1)
            end_upload=$(date +%s.%N)
            upload_time=$(echo "scale=3; $end_upload - $start_upload" | bc)
            
            # Extract hash and validate
            hash=$(echo "$upload_output" | tail -n 1 | grep -Eo "Qm[1-9A-HJ-NP-Za-km-z]{44}")
            if [[ -z "$hash" ]]; then
                echo "Error extracting IPFS hash: $upload_output"
                continue
            fi
            
            # Capture upload metrics
            metrics=$(get_metrics $upload_container)
            
            # Ensure file is pinned on the uploading node before downloading
            docker exec $upload_container ipfs pin add "$hash"
            
            # Download file
            echo "[$topology] $container downloading $hash"
            start_download=$(date +%s.%N)
            download_output=$(docker exec $container ipfs get "$hash" -o "/root/$filename" 2>&1)
            end_download=$(date +%s.%N)
            download_time=$(echo "scale=3; $end_download - $start_download" | bc)
            
            if [ $? -eq 0 ]; then
                # Capture download metrics
                download_metrics=$(get_metrics $container)
                
                # Calculate bandwidths
                upload_bandwidth_bps=$(echo "scale=3; $file_size_bytes / $upload_time" | bc)
                upload_bandwidth_mbps=$(echo "scale=3; $upload_bandwidth_bps * 8 / 1000000" | bc)
                download_bandwidth_bps=$(echo "scale=3; $file_size_bytes / $download_time" | bc)
                download_bandwidth_mbps=$(echo "scale=3; $download_bandwidth_bps * 8 / 1000000" | bc)
                
                # Log results
                echo "$topology,$file_size_mb,$upload_time,$download_time,$metrics,$file_size_mb,$file_size_mb,$upload_bandwidth_mbps,$download_bandwidth_mbps" >> $METRICS_FILE
            else
                echo "Error downloading file: $download_output"
            fi

            counter=$((counter + 1))
        done
    done
}

# Run simulations for each topology
for topology in ring grid barabasi complete; do
    run_simulation $topology
done

echo "Simulation complete. Results saved in $LOG_DIR"
