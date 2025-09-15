# EFK Stack for Kubernetes Log Management

A production-ready Elasticsearch, Fluentd, and Kibana (EFK) stack for Kubernetes log aggregation with advanced alert processing and flexible routing configurations.

## Overview

This project provides comprehensive log collection and processing for Kubernetes environments with specialized support for alert log parsing, multi-namespace deployments, and configurable indexing strategies. The stack includes multiple Fluentd configurations optimized for different deployment scenarios.

## Features

- **Alert Log Processing**: Automatic detection and field extraction from ALERT log entries
- **Multi-Namespace Support**: Configurable log collection across multiple Kubernetes namespaces
- **Flexible Indexing**: Multiple routing strategies including centralized, per-namespace, and time-series indexing
- **Production Ready**: Includes RBAC, service accounts, and security configurations
- **Validated Configurations**: Production-ready configurations with comprehensive validation

## Architecture

### Components

- **Fluentd DaemonSet**: Collects container logs from all nodes
- **Elasticsearch**: Stores and indexes log data with configurable retention
- **Kibana**: Provides visualization and search capabilities
- **ConfigMaps**: Multiple configurations for different deployment scenarios
- **RBAC**: Proper security controls and service account permissions

### Log Processing Pipeline

1. **Collection**: Fluentd tails container logs from `/var/log/containers/`
2. **Enrichment**: Kubernetes metadata filter adds pod, namespace, and container information
3. **Alert Detection**: Identifies and parses ALERT log entries with structured field extraction
4. **Routing**: Logs are routed to appropriate Elasticsearch indices based on configuration
5. **Storage**: Indexed in Elasticsearch with configurable retention policies

## Quick Start

### Prerequisites

- Kubernetes cluster (v1.20+)
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

3. **Deploy the Fluentd DaemonSet:**
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

## Alert Log Format

The system automatically detects and parses ALERT logs in this format:

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
5. Document in analysis file

## Contributing

1. Fork the repository
2. Create a feature branch
3. Validate configuration changes
4. Update documentation
5. Submit a pull request

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

## License

This project is provided as-is for educational and production use.

