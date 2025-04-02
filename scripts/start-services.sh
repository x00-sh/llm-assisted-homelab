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

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        handle_error "Command not found: $1"
    fi
}

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" || handle_error "Failed to get script directory"

# Check if required files exist
check_file "$SCRIPT_DIR/regenerate-dns.sh"
check_file "$SCRIPT_DIR/../podman-compose.yml"
check_file "$SCRIPT_DIR/../.env"

# Check if required commands exist
check_command "podman-compose"

# Generate DNS records
echo "Generating DNS records..."
"$SCRIPT_DIR/regenerate-dns.sh" || handle_error "Failed to generate DNS records"

# Start services
echo "Starting services..."
cd "$SCRIPT_DIR/.." || handle_error "Failed to change directory"
podman-compose up -d || handle_error "Failed to start services"

# Verify services are running
if ! podman-compose ps | grep -q "Up"; then
    handle_error "Some services failed to start. Check logs with 'podman-compose logs'"
fi

echo "Services started successfully!"
echo "To view logs, run: podman-compose logs -f"
echo "To stop services, run: podman-compose down"
echo "To regenerate DNS records, run: ./scripts/regenerate-dns.sh" 