#!/bin/bash

# Load environment variables
set -a
source ../.env
set +a

# Convert comma-separated lists to JSON arrays
ADMIN_USERS_JSON=$(echo "\"${ADMIN_USERS}\"" | sed 's/,/","/g')
MEDIA_USERS_JSON=$(echo "\"${MEDIA_USERS}\"" | sed 's/,/","/g')
GUEST_USERS_JSON=$(echo "\"${GUEST_USERS}\"" | sed 's/,/","/g')

# Process ACL file with environment variables
envsubst < /etc/headscale/acl.hujson.template | \
  sed "s|\"${ADMIN_USERS}\"|[${ADMIN_USERS_JSON}]|g" | \
  sed "s|\"${MEDIA_USERS}\"|[${MEDIA_USERS_JSON}]|g" | \
  sed "s|\"${GUEST_USERS}\"|[${GUEST_USERS_JSON}]|g" > /etc/headscale/acl.hujson

# Start Headscale
exec headscale serve 