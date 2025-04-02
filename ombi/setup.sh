#!/bin/bash

# Wait for services to be ready
sleep 30

# Get API keys
SONARR_API=$(curl -s "http://100.64.0.3:8989/api/v3/system/status?apikey=" | jq -r '.apiKey')
RADARR_API=$(curl -s "http://100.64.0.4:7878/api/v3/system/status?apikey=" | jq -r '.apiKey')

# Update Ombi config
sed -i "s/\"ApiKey\": \"\"/\"ApiKey\": \"$SONARR_API\"/" /config/settings.json
sed -i "s/\"ApiKey\": \"\"/\"ApiKey\": \"$RADARR_API\"/" /config/settings.json

# Restart Ombi
curl -X POST "http://localhost:5000/api/v1/Ombi/settings" -H "Content-Type: application/json" -d @/config/settings.json 