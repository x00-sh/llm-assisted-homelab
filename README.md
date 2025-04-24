# 🏠 Homelab Setup

This repository contains the configuration for my homelab services, managed using Podman and organized into logical service groups. All services are only accessible via the Headscale VPN network.

## 🚀 Services

- **🔄 Traefik**: Reverse proxy and SSL termination (Headscale-only)
- **🌐 Headscale**: Open-source Tailscale control server
- **🎬 Jellyfin**: Media server (Headscale-only)
- **📦 Portainer**: Container management (Headscale-only)
- **🎯 Ombi**: Media request management (Headscale-only)
- **📺 Sonarr**: TV show management (Headscale-only)
- **🎥 Radarr**: Movie management (Headscale-only)
- **📥 SABnzbd**: Usenet downloader (Headscale-only)
- **📊 Prometheus**: Metrics collection (Headscale-only)
- **📈 Grafana**: Metrics visualization (Headscale-only)
- **📊 Node Exporter**: System metrics collection (Headscale-only)

## 🔒 Security

### Network Isolation
- All services are only accessible via the Headscale VPN network
- No public ports are exposed
- Services communicate over the encrypted Tailscale network
- Local network access is restricted to the Tailscale subnet (100.64.0.0/10)

### Access Control
- **👑 admin**: Full access to all services
- **🎮 media-admin**: Access to media management services
- **👤 media-user**: Access to media consumption services

### Authentication
- All services require Headscale authentication
- Additional basic auth for sensitive services (Traefik, Prometheus, Grafana)
- API keys for service-to-service communication

## 🌐 DNS Resolution

This setup uses Headscale's built-in DNS capabilities for service resolution. When connected to the Headscale network:

1. All services are accessible via their hostname (e.g., `sonarr.${DOMAIN}`, `radarr.${DOMAIN}`)
2. DNS resolution works automatically for all connected devices
3. Services are resolved to their Tailscale IP addresses (100.64.0.0/10)
4. Local DNS is overridden to ensure proper resolution

### 🔧 How it works:

1. Headscale acts as a DNS server for the `${DOMAIN}` domain
2. Each service is registered with its Tailscale IP address
3. When a client queries a service name, Headscale returns the correct IP
4. MagicDNS is enabled for automatic resolution

## 📊 Monitoring

The setup includes Prometheus and Grafana for comprehensive monitoring. All monitoring services are only accessible via Headscale.

### System Monitoring
- **Node Exporter Full** (ID: 1860)
  - CPU, memory, disk usage
  - Network statistics
  - System uptime
  - Temperature monitoring

### Media Services
- **Sonarr/Radarr Stats** (ID: 10891)
  - Library statistics
  - Queue status
  - Recent additions
  - Missing episodes/movies

- **SABnzbd Stats** (ID: 10892)
  - Download speed
  - Queue status
  - Disk usage
  - Completion rate

- **Headscale Stats** (ID: 10893)
  - Active users
  - Connection status
  - Network traffic
  - Device statistics

## 💻 Development

This project was developed using several AI-powered tools:

### 🛠️ Tools Used
- **🔧 Continue Extension**: Primary development environment with AI code completion and chat in VS Code
- **🔍 Code Search**: Semantic code search for finding relevant code snippets
- **💻 Terminal Integration**: AI-assisted terminal command execution
- **🏠 Ollama**: Local LLM instance for offline code assistance

### 💪 Hardware
- **🎮 NVIDIA 5090**: GPU-accelerated local model inference

### 🔄 Development Process
1. 🚀 Iterative Development: Using AI to quickly prototype and refine configurations
2. ⚡ Code Generation: AI-assisted creation of configuration files and scripts
3. ✍️ Documentation: AI-assisted writing and updating of documentation
4. 🔧 Troubleshooting: AI-powered debugging and problem-solving

### 🎯 AI Assistance Areas
- Container configuration and networking
- Security best practices implementation
- Documentation writing and organization
- Service integration and optimization
- GPU-accelerated local model inference

## 📝 Notes

- 📁 Media paths are mounted at `/media` and `/downloads`
- ⚙️ All services use environment variables for configuration
- 🔒 Access control is managed through Headscale ACLs
- 🌐 DNS resolution is handled automatically by Headscale
- 🚫 No public ports are exposed
- 🔐 All traffic is encrypted via Tailscale
- 🤖 DNS records are automatically generated when starting services
- 🔄 DNS records can be regenerated without restarting services 

