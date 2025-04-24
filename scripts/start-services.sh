#!/bin/bash

# Exit on error
set -e

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Source the compose tools script
source "$(dirname "${BASH_SOURCE[0]}")/compose-tools.sh"

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" || handle_error "Failed to get script directory"

# Check if required files exist
check_file "$SCRIPT_DIR/regenerate-dns.sh"
check_file "$SCRIPT_DIR/../podman-compose.yml"
check_file "$SCRIPT_DIR/../.env"

# Find the compose command
COMPOSE_CMD=$(get_compose_tool) || handle_error "Failed to determine container orchestration tool."
echo "Using $COMPOSE_CMD as container orchestration tool"

# Generate DNS records (will also start Headscale if not running)
echo "Generating DNS records..."
"$SCRIPT_DIR/regenerate-dns.sh" || handle_error "Failed to generate DNS records"

# Start services
echo "Starting services..."
cd "$SCRIPT_DIR/.." || handle_error "Failed to change directory"
$COMPOSE_CMD up -d || handle_error "Failed to start services"

# Verify services are running
if ! $COMPOSE_CMD ps | grep -q "Up"; then
    handle_error "Some services failed to start. Check logs with '$COMPOSE_CMD logs'"
fi

echo "Services started successfully!"
echo "To view logs, run: $COMPOSE_CMD logs -f"
echo "To stop services, run: $COMPOSE_CMD down"
echo "To regenerate DNS records at any time, run: ./scripts/regenerate-dns.sh"
