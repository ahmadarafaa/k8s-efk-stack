# Multi-Namespace Example

This example demonstrates how to collect logs from multiple namespaces simultaneously. This configuration is suitable for environments with different teams or deployment stages.

## Files Included
- `namespaces.yaml` - Creates test namespaces for demonstration
- `deployments.yaml` - Sample applications deployed across namespaces
- `fluentd-config.yaml` - Multi-namespace Fluentd configuration
- `elasticsearch-config-and-secret.yaml` - Elasticsearch connection and credentials

## Deployment Steps

1. Create the test namespaces:
   ```bash
   kubectl apply -f namespaces.yaml
   ```

2. Deploy Elasticsearch configuration:
   ```bash
   kubectl apply -f elasticsearch-config-and-secret.yaml
   ```

3. Apply the multi-namespace Fluentd configuration:
   ```bash
   kubectl apply -f fluentd-config.yaml
   ```

4. Deploy the test applications:
   ```bash
   kubectl apply -f deployments.yaml
   ```

5. Start the Fluentd DaemonSet:
   ```bash
   kubectl apply -f ../../fluentd-solution/configs/fluentd-daemonset.yaml
   ```

## Expected Results
- Log collection from `production`, `staging`, `development`, and `logging-test` namespaces
- Alert logs centralized in the `centralized-alert-logs` index
- Application logs organized in namespace-specific indices such as `production_web-app` and `staging_api-service`