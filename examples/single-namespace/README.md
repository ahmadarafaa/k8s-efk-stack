# Single Namespace Example

This example demonstrates log collection from a single namespace. This configuration is ideal for testing or environments with isolated application deployments.

## Files Included
- `deployment.yaml` - Test application for log generation
- `fluentd-config.yaml` - Single namespace Fluentd configuration
- `elasticsearch-config-and-secret.yaml` - Elasticsearch connection and credentials

## Deployment Steps

1. Deploy Elasticsearch configuration:
   ```bash
   kubectl apply -f elasticsearch-config-and-secret.yaml
   ```

2. Apply the Fluentd configuration:
   ```bash
   kubectl apply -f fluentd-config.yaml
   ```

3. Deploy the test application:
   ```bash
   kubectl apply -f deployment.yaml
   ```

4. Start the Fluentd DaemonSet:
   ```bash
   kubectl apply -f ../../fluentd-solution/configs/fluentd-daemonset.yaml
   ```

## Expected Results
- Log collection from the `logging-test` namespace
- Automatic parsing of structured log patterns when present
- Proper routing of different log types to appropriate Elasticsearch indices