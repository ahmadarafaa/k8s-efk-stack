# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an EFK (Elasticsearch, Fluentd, Kibana) stack configuration for Kubernetes log aggregation and monitoring. The repository contains Kubernetes manifests for deploying Fluentd log collection with audit filtering capabilities.

## Architecture

### Components
- **Fluentd DaemonSet**: Runs on each node to collect container logs from `/var/log/containers/*.log`
- **ConfigMap**: Contains Fluentd configuration with audit log filtering and Elasticsearch output
- **Test Deployments**: Sample applications (web-service, api-service, worker-service) for testing log collection

### Log Processing Pipeline
1. **Collection**: Fluentd tails container logs using regex parsing
2. **Enrichment**: Kubernetes metadata filter adds pod/namespace/container information
3. **Filtering**: Only logs containing `[AUDIT]` pattern are processed
4. **Transformation**: Records are enriched with timestamp, pod details, and host information
5. **Output**: Logs are sent to Elasticsearch cluster with authentication

### Key Configuration Details
- **Namespace**: All components deploy to `logging` namespace
- **Elasticsearch**: Configured to connect to host `10.0.0.180:9200` with HTTPS and authentication
- **Index**: Logs are stored in `auditor-test` index
- **RBAC**: ServiceAccount with ClusterRole permissions to read pods and namespaces
- **Security**: SSL verification disabled for Elasticsearch, credentials stored in ConfigMap/Secret

## Deployment Commands

```bash
# Deploy the complete EFK stack
kubectl apply -f fluentd-daemonset.yaml
kubectl apply -f fluentd-bit-configmap-working.yaml

# Deploy test applications for log generation
kubectl apply -f test-deploy.yaml

# Verify deployments
kubectl get pods -n logging
kubectl get daemonset -n logging

# View Fluentd logs
kubectl logs -n logging -l k8s-app=fluentd-logging

# Delete all components
kubectl delete -f fluentd-daemonset.yaml
kubectl delete -f fluentd-bit-configmap-working.yaml
kubectl delete -f test-deploy.yaml
```

## Configuration Management

### Modifying Fluentd Configuration
- Edit `fluentd-bit-configmap-working.yaml` for log parsing, filtering, or output changes
- ConfigMap changes require pod restart: `kubectl rollout restart daemonset/fluentd -n logging`

### Elasticsearch Connection
- Host/port configured in `fluentd-bit-configmap-working.yaml:56-57`
- Credentials in ConfigMap and Secret references in `fluentd-daemonset.yaml:74-83`

### Audit Log Filtering
- Filter pattern defined in `fluentd-bit-configmap-working.yaml:35-39`
- Currently filters for logs containing `[AUDIT]` string

## Security Considerations

**WARNING**: The current configuration contains hardcoded credentials and disables SSL verification. For production use:
- Move credentials to Kubernetes Secrets
- Enable proper SSL certificate verification
- Use network policies to restrict access
- Review RBAC permissions for least privilege