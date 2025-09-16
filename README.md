# EFK Stack for Kubernetes Log Management

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Kubernetes-326CE5.svg)
![YAML](https://img.shields.io/badge/Config-YAML-blue.svg)
![Fluentd](https://img.shields.io/badge/Logging-Fluentd-yellow.svg)
![Elasticsearch](https://img.shields.io/badge/Search-Elasticsearch-005571.svg)
![Kibana](https://img.shields.io/badge/Visualization-Kibana-e8478b.svg)

> **Streamline Kubernetes log management with production-ready EFK stack, featuring advanced pattern detection, multi-namespace support, and flexible routing configurations. This stack brings comprehensive log aggregation and processing to modern containerized environments.**

## Table of Contents

<table width="100%">
<tr>
<td width="50%" valign="top">

### **<u>Getting Started</u>**
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
  - [Components](#components)
  - [Log Processing Pipeline](#log-processing-pipeline)
- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Basic Deployment](#basic-deployment)

### **<u>Configuration & Setup</u>**
- [Configuration Options](#configuration-options)
  - [Available ConfigMaps](#available-configmaps)
  - [Environment Variables](#environment-variables)
- [Custom Log Pattern Processing](#custom-log-pattern-processing)
  - [Example: Alert Log Format](#example-alert-log-format)
  - [Custom Pattern Configuration](#custom-pattern-configuration)

</td>
<td width="50%" valign="top">

### **<u>Operations & Monitoring</u>**
- [Index Patterns](#index-patterns)
  - [Alert Indices](#alert-indices)
  - [Application Indices](#application-indices)
- [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)
  - [Check Deployment Status](#check-deployment-status)
  - [Common Issues](#common-issues)

### **<u>Development & Support</u>**
- [Development](#development)
  - [File Structure](#file-structure)
  - [Adding New Configurations](#adding-new-configurations)
- [Security Considerations](#security-considerations)
- [Future Work](#future-work)
- [Contributing](#contributing)
- [License](#license)

</td>
</tr>
</table>

## Overview

This project provides comprehensive log collection and processing for Kubernetes environments with specialized support for custom log pattern processing, multi-namespace deployments, and configurable indexing strategies. The stack includes multiple Fluentd configurations optimized for different deployment scenarios.

## Features

- **Custom Log Processing**: Automatic detection and field extraction from configurable log patterns
- **Multi-Namespace Support**: Configurable log collection across multiple Kubernetes namespaces
- **Flexible Indexing**: Multiple routing strategies including centralized, per-namespace, and time-series indexing
- **Production Ready**: Includes RBAC, service accounts, and security configurations

## Architecture

### Components

- **Fluentd DaemonSet**: Collects container logs from all nodes
- **ConfigMaps**: Multiple configurations for different deployment scenarios
- **RBAC**: Proper security controls and service account permissions

### Log Processing Pipeline

1. **Collection**: Fluentd tails container logs from `/var/log/containers/` on each node
2. **Enrichment**: Kubernetes metadata filter adds pod, namespace, and container information
3. **Pattern Detection**: Identifies and parses custom log patterns with structured field extraction
4. **Routing**: Logs are routed to appropriate Elasticsearch indices based on configuration
5. **Storage**: Indexed in Elasticsearch with configurable retention policies

## Quick Start

### Prerequisites

- Kubernetes cluster (v1.16+)
- kubectl configured
- Elasticsearch cluster or instance

### Basic Deployment

1. **Deploy Elasticsearch configuration:**
```bash
kubectl apply -f fluentd-solution/configs/elasticsearch-config.yaml
kubectl apply -f fluentd-solution/configs/elasticsearch-secret.yaml
```

2. **Choose and deploy a Fluentd configuration:**
```bash
# For single namespace deployment
kubectl apply -f fluentd-solution/configs/fluentd-single-namespace-alert-config.yaml

# For cluster-wide deployment
kubectl apply -f fluentd-solution/configs/fluentd-all-except-system-config.yaml
```

3. **Configure and deploy the Fluentd DaemonSet:**

   First, edit the DaemonSet configuration to reference your chosen ConfigMap:
   ```bash
   # Edit the DaemonSet file to match your chosen ConfigMap name
   # Update line 121 in fluentd-daemonset.yaml:
   # configMap:
   #   name: your-chosen-configmap-name
   ```

   Then deploy the DaemonSet:
   ```bash
   kubectl apply -f fluentd-solution/configs/fluentd-daemonset.yaml
   ```



## Configuration Options

### Available ConfigMaps

| Configuration | Purpose | Scope | Best For |
|--------------|---------|--------|----------|
| `fluentd-minimal-basic-config` | Simple log collection | All namespaces | Development environments |
| `fluentd-single-namespace-alert-config` | Single namespace with ALERT processing | One namespace | Single application deployments |
| `fluentd-all-except-system-config` | Cluster-wide collection | All non-system namespaces | Production clusters |
| `fluentd-multi-namespace-centralized-alert-config` | Multi-namespace with centralized alerts | Selected namespaces | Security operations centers |
| `fluentd-multi-namespace-per-ns-alert-config` | Multi-namespace with distributed alerts | Selected namespaces | Team-based alert management |
| `fluentd-environment-based-config` | Time-series indexing | Environment-specific | Analytics and long-term storage |

### Environment Variables

Configure these environment variables in the Elasticsearch ConfigMap:

```yaml
elasticsearch-host: "your-elasticsearch-host"
elasticsearch-port: "9200"
elasticsearch-scheme: "http"  # or "https"
elasticsearch-username: "elastic"
```

Set the password in the Elasticsearch Secret:

```yaml
password: "your-base64-encoded-password"
```

## Custom Log Pattern Processing

The system can be configured to automatically detect and parse custom log patterns with structured field extraction. You can define any pattern string relevant to your application.

### Example: Alert Log Format

Configure the system to detect and parse logs with patterns like "ALERT":

```
ALERT user=username,action=action_name,status=success,Field=field_name,old_value=old,new_value=new
```

Extracted fields:
- `User`: Username who triggered the alert
- `Action`: Action that was performed
- `Status`: Operation status
- `Field`: Field that was modified
- `Old_value`: Previous value
- `New_value`: New value

### Custom Pattern Configuration

You can customize the pattern detection by modifying the Fluentd configuration to handle any log format specific to your application needs.

## Index Patterns

### Alert Indices
- **Single namespace**: `alerts_logging-test`
- **Per-namespace**: `alerts_{namespace}`
- **Centralized**: `centralized-alert-logs`
- **Cluster-wide**: `alerts_cluster`
- **Time-series**: `{service}_{app}-alert-YYYY-MM`

### Application Indices
- **Namespace-app format**: `{namespace}_{app}`
- **Service-app format**: `{service}_{app}`
- **Dynamic**: `{target_index}`
- **Generic fallback**: `multi-namespace-generic`

## Monitoring and Troubleshooting

### Check Deployment Status

```bash
# Verify pods are running
kubectl get pods -n logging

# Check Fluentd logs
kubectl logs -l k8s-app=fluentd-logging -n logging

# Verify ConfigMaps
kubectl get configmap -n logging
```

### Common Issues

1. **Pod not starting**: Check ConfigMap name in DaemonSet matches deployed ConfigMap
2. **No logs in Elasticsearch**: Verify Elasticsearch connection and credentials
3. **ALERT parsing not working**: Ensure log format matches expected pattern
4. **Missing indices**: Check namespace filtering and log routing configuration

## Development

### File Structure

```
├── fluentd-solution/
│   └── configs/                    # Fluentd configurations
└── README.md                       # This file
```

### Adding New Configurations

1. Create new ConfigMap in `fluentd-solution/configs/`
2. Follow naming convention: `fluentd-{purpose}-config.yaml`
3. Update DaemonSet to reference new ConfigMap
4. Validate configuration functionality
5. Test configuration and validate functionality

## Security Considerations

- **Credentials**: Store Elasticsearch credentials in Kubernetes Secrets
- **RBAC**: Use provided service accounts and cluster roles
- **Network Security**: Configure appropriate network policies
- **SSL/TLS**: Enable SSL verification for production Elasticsearch clusters
- **Access Control**: Implement appropriate Elasticsearch access controls

## Future Work

- [ ] **Helm Chart**: Complete Helm chart for easy deployment and management
- [ ] **Advanced Monitoring**: Prometheus metrics integration
- [ ] **Log Retention Policies**: Automated index lifecycle management
- [ ] **Multi-cluster Support**: Cross-cluster log aggregation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Validate configuration changes
4. Update documentation
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

