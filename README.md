# EFK Stack with Audit Trail Logging

## Deploy Applications

```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy test applications
kubectl apply -n logging-test -f k8s/deployments/app-logs.yaml

# Update Fluentd configuration
kubectl apply -f fluentd-configmap-claude.yaml

# Restart Fluentd DaemonSet to pick up new config
kubectl rollout restart daemonset/fluentd -n logging
```

## Verify Deployments

```bash
# Check pods are running
kubectl get pods -n logging-test

# View audit service logs (contains [AUDIT] lines)
kubectl logs -n logging-test deployment/audit-service

# View api-gateway logs
kubectl logs -n logging-test deployment/api-gateway

# View jobs-worker logs
kubectl logs -n logging-test deployment/jobs-worker
```

## Expected Elasticsearch Indices

- `audit-trail-YYYY.MM.DD` - All logs containing `[AUDIT]` pattern
- `api-gateway-YYYY.MM.DD` - Logs from api-gateway deployment
- `jobs-worker-YYYY.MM.DD` - Logs from jobs-worker deployment
- `audit-service-YYYY.MM.DD` - Non-audit logs from audit-service deployment

## Environment Variables Required

Fluentd DaemonSet needs these environment variables:
- `ES_HOST` - Elasticsearch host
- `ES_PORT` - Elasticsearch port
- `ES_USER` - Elasticsearch username
- `ES_PASSWORD` - Elasticsearch password