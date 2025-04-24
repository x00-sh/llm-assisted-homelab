# Project Context for AI Assistants

## Project Overview
- **Type**: Homelab Infrastructure
- **Location**: `/opt/llm-assisted-homelab`
- **Container Runtime**: Podman
- **Network**: Headscale VPN (Tailscale-compatible)
- **Access**: Headscale-only, no public ports

## Key Files
- `.env`: Environment configuration
- `podman-compose.yml`: Main service orchestration
- `compose/`: Directory containing service-specific compose files
- `scripts/`: Automation and utility scripts

## Service Architecture
### Core Infrastructure
- **Traefik**: Reverse proxy (port 80, 443)
- **Headscale**: VPN control server
- **Portainer**: Container management

### Media Stack
- **Jellyfin**: Media server
- **Sonarr**: TV management
- **Radarr**: Movie management
- **SABnzbd**: Usenet downloader
- **Ombi**: Media requests

### Monitoring Stack
- **Prometheus**: Metrics collection
- **Grafana**: Visualization
- **Loki**: Log aggregation
- **Promtail**: Log collection

## Security Model
### Access Levels
1. **Admin**: Full access
2. **Media Admin**: Media management
3. **Media User**: Media consumption

### Network Security
- All services on Headscale VPN
- No public ports
- Encrypted communication
- ACL-based access control

## Important Paths
- Media: `/mnt/media`
- Downloads: `/mnt/downloads`

## Development Guidelines
- Use environment variables for configuration
- Follow GitOps practices
- Maintain security-first approach
- Document all changes
- Test in isolated environment first

## Common Tasks
1. Adding new services:
   - Create service directory
   - Add compose file
   - Update environment variables
   - Configure Traefik labels
   - Update documentation

2. Updating services:
   - Check for breaking changes
   - Update environment variables
   - Test in isolation
   - Deploy with zero downtime

3. Troubleshooting:
   - Check logs in Portainer
   - Verify Headscale connectivity
   - Review Traefik logs
   - Check service health endpoints

## AI Assistant Context
When working with this project, focus on:
- Security best practices
- Zero-downtime deployments
- Configuration management
- Monitoring and logging
- Documentation maintenance
- Automation opportunities 