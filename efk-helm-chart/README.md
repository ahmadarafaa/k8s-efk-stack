# EFK Fluentd Helm Chart

A Helm chart for deploying Fluentd with dynamic log collection and audit trail support in Kubernetes.

## Features

- **Dynamic Log Collection**: Automatically discovers and indexes logs from configured namespaces
- **Audit Trail Support**: Parse and route audit logs with structured fields
- **Flexible Index Naming**: Support for `namespace_app` or `namespace-app` formats
- **Multiple Audit Strategies**: Centralized or per-namespace audit trails
- **Production Ready**: RBAC, security contexts, resource limits, and tolerations

## Installation

### Basic Installation
```bash
helm install fluentd ./efk-helm-chart -n logging --create-namespace
```

### Custom Values
```bash
helm install fluentd ./efk-helm-chart -n logging --create-namespace \
  --set elasticsearch.host=your-es-host.com \
  --set elasticsearch.username=your-username \
  --set elasticsearch.password=your-password
```

### Environment-Specific Installation
```bash
# Development
helm install fluentd ./efk-helm-chart -n logging --create-namespace \
  --set logging.namespaces="{dev,testing}" \
  --set logging.audit.strategy=centralized

# Production
helm install fluentd ./efk-helm-chart -n logging --create-namespace \
  --set logging.namespaces="{production,monitoring}" \
  --set logging.audit.strategy=per-namespace
```

## Configuration

### Key Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `fluentd.image.tag` | Fluentd image tag | `v1.19.0-debian-elasticsearch8-1.0` |
| `elasticsearch.host` | Elasticsearch host | `10.0.0.180` |
| `elasticsearch.port` | Elasticsearch port | `9200` |
| `logging.namespaces` | Namespaces to collect logs from | `[logging-test, production, staging, development]` |
| `logging.audit.enabled` | Enable audit log parsing | `true` |
| `logging.audit.strategy` | Audit strategy: `centralized` or `per-namespace` | `centralized` |
| `logging.indexFormat` | Index format: `namespace_app` or `namespace-app` | `namespace_app` |

### Audit Log Format

The chart expects audit logs in this format:
```
[AUDIT] user=pocuser,action=execute,project=NewPOC,status=success,Field=Task,old_value=pending,new_value=completed
```

Parsed fields: `User`, `Action`, `Project`, `Status`, `Field`, `Old_value`, `New_value`

## Index Structure

### Application Logs
- Format: `{namespace}_{app}` (e.g., `production_web-service`)
- Contains: Regular application logs with Kubernetes metadata

### Audit Logs
- **Centralized**: `centralized_audit-trail`
- **Per-Namespace**: `{namespace}_audit-trail` (e.g., `production_audit-trail`)

## Upgrade

```bash
# Change namespaces
helm upgrade fluentd ./efk-helm-chart --set logging.namespaces="{new-namespace}"

# Switch audit strategy
helm upgrade fluentd ./efk-helm-chart --set logging.audit.strategy=per-namespace

# Update Elasticsearch endpoint
helm upgrade fluentd ./efk-helm-chart \
  --set elasticsearch.host=new-host.com \
  --set elasticsearch.username=new-user \
  --set elasticsearch.password=new-pass
```

## Uninstall

```bash
helm uninstall fluentd -n logging
```

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods -l k8s-app=fluentd-logging -n logging
```

### View Logs
```bash
kubectl logs -l k8s-app=fluentd-logging -n logging
```

### Verify Configuration
```bash
kubectl describe configmap fluentd-config -n logging
```

### Test Log Generation
```bash
kubectl run test-pod --image=busybox --restart=Never -- sh -c 'echo "[AUDIT] user=testuser,action=create,project=TestProj,status=success,Field=Resource,old_value=none,new_value=created"'
```

## Security Considerations

- Credentials are stored in Kubernetes Secrets
- RBAC permissions limited to reading pods and namespaces
- Security contexts applied to pods
- SSL verification configurable