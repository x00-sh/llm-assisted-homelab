#!/bin/bash

# Exit on error
set -e

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to check if a file exists
check_file() {
    if [ ! -f "$1" ]; then
        handle_error "File not found: $1"
    fi
}

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" || handle_error "Failed to get script directory"
COMPOSE_FILE="$SCRIPT_DIR/../podman-compose.yml"
CONFIG_FILE="$SCRIPT_DIR/../headscale/config/config.yaml"

# Check if required files exist
check_file "$COMPOSE_FILE"
check_file "$CONFIG_FILE"

# Function to generate DNS records
generate_dns_records() {
    local ip_base="100.64.0"
    local ip_counter=3  # Start at 3 since 1 and 2 are reserved
    
    # Start of DNS records section with fixed IPs
    echo "  extra_records:"
    echo "    - name: \"traefik\""
    echo "      type: \"A\""
    echo "      value: \"${ip_base}.1\""
    echo "    - name: \"headscale\""
    echo "      type: \"A\""
    echo "      value: \"${ip_base}.2\""
    
    # Read services from compose file
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*([a-zA-Z0-9_-]+): ]]; then
            service_name="${BASH_REMATCH[1]}"
            # Skip services that already have fixed IPs
            if [[ "$service_name" != "traefik" && "$service_name" != "headscale" ]]; then
                echo "    - name: \"$service_name\""
                echo "      type: \"A\""
                echo "      value: \"$ip_base.$ip_counter\""
                ((ip_counter++))
            fi
        fi
    done < "$COMPOSE_FILE"
}

# Generate new DNS records
NEW_DNS_RECORDS=$(generate_dns_records) || handle_error "Failed to generate DNS records"

# Create backup of config file
BACKUP_FILE="$CONFIG_FILE.bak"
cp "$CONFIG_FILE" "$BACKUP_FILE" || handle_error "Failed to create backup of config file"

# Update config file
awk -v new_records="$NEW_DNS_RECORDS" '
    /^  extra_records:/ { 
        print new_records; 
        while (getline && /^    - name:/) { continue; } 
        if ($0 !~ /^  extra_records:/) print $0; 
        next 
    }
    { print }
' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" || handle_error "Failed to update config file"

# Verify the new config file
if [ ! -s "$CONFIG_FILE.tmp" ]; then
    mv "$BACKUP_FILE" "$CONFIG_FILE"
    handle_error "Generated config file is empty"
fi

# Replace original file with temp file
mv "$CONFIG_FILE.tmp" "$CONFIG_FILE" || handle_error "Failed to replace config file"

# Restart Headscale to apply DNS changes
echo "Restarting Headscale to apply DNS changes..."
cd "$SCRIPT_DIR/.." && podman-compose restart headscale || handle_error "Failed to restart Headscale"

echo "DNS records updated successfully in $CONFIG_FILE"
echo "Backup created at $BACKUP_FILE"
echo "Headscale restarted to apply changes"
echo "Fixed IPs:"
echo "  - traefik: 100.64.0.1"
echo "  - headscale: 100.64.0.2"
echo "Other services assigned IPs dynamically" 