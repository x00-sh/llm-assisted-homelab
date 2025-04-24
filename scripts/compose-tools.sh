#!/bin/bash

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

# Function to check if a file exists
check_file() {
    if [ ! -f "$1" ]; then
        handle_error "File not found: $1"
    fi
}

# Function to find the compose command (podman or docker)
find_compose_command() {
    # Try newer syntax first (podman compose)
    if check_command "podman"; then
        if [ -n "$(podman --help | grep 'compose')" ]; then
            echo "podman compose"
            return 0
        else
            if check_command "podman-compose"; then
                echo "podman-compose"
                return 0
            fi
        fi
    # Try newer syntax for docker (docker compose)
    elif check_command "docker"; then
        if [ -n "$(docker --help | grep 'compose')" ]; then
            echo "docker compose"
            return 0
        else
            if check_command "docker-compose"; then
                echo "docker-compose"
                return 0
            fi
        fi
    fi
    return 1
}

# Function to get the compose command and handle errors
get_compose_tool() {
    local compose_cmd=$(find_compose_command)
    
    if [ -z "$compose_cmd" ]; then
        echo "Error: Neither podman nor docker found. Please install one of them." >&2
        exit 1
    fi
    
    echo "$compose_cmd"
}

# Export functions so they can be used when sourced
export -f check_command
export -f check_file
export -f find_compose_command
export -f get_compose_tool