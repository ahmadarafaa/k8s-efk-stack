# Multi-Namespace Example

Ready to go big? This example shows you how to collect logs from multiple namespaces at once. Perfect for when you have different environments or teams.

## What's Here
- `namespaces.yaml` - Creates some test namespaces
- `deployments.yaml` - Test apps in different namespaces
- `fluentd-config.yaml` - Multi-namespace Fluentd setup
- `elasticsearch-config-and-secret.yaml` - Elasticsearch connection and credentials

## How to Set It Up

1. Make some namespaces:
   ```bash
   kubectl apply -f namespaces.yaml
   ```

2. Connect to Elasticsearch:
   ```bash
   kubectl apply -f elasticsearch-config-and-secret.yaml
   ```

3. Set up Fluentd for multiple namespaces:
   ```bash
   kubectl apply -f fluentd-config.yaml
   ```

4. Deploy test apps in each namespace:
   ```bash
   kubectl apply -f deployments.yaml
   ```

5. Fire up Fluentd:
   ```bash
   kubectl apply -f ../../fluentd-solution/configs/fluentd-daemonset.yaml
   ```

## What You Should See
- Logs flowing in from `production`, `staging`, `development`, and `logging-test` namespaces
- Alert logs get collected into one central index called `centralized-alert-logs`
- Regular app logs get sorted into indices like `production_web-app`, `staging_api-service`, etc.