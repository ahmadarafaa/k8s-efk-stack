# Single Namespace Example

Want to try this on just one namespace first? Smart move! This example shows you how to get logs from a single namespace.

## What's Here
- `deployment.yaml` - A test app to generate some logs
- `fluentd-config.yaml` - Fluentd setup for single namespace
- `elasticsearch-config-and-secret.yaml` - Elasticsearch connection and credentials

## How to Set It Up

1. Tell Fluentd where your Elasticsearch is:
   ```bash
   kubectl apply -f elasticsearch-config-and-secret.yaml
   ```

2. Set up the Fluentd config:
   ```bash
   kubectl apply -f fluentd-config.yaml
   ```

3. Deploy a test app to make some logs:
   ```bash
   kubectl apply -f deployment.yaml
   ```

4. Start up Fluentd:
   ```bash
   kubectl apply -f ../../fluentd-solution/configs/fluentd-daemonset.yaml
   ```

## What You Should See
- Logs start showing up from the `logging-test` namespace
- If your app logs have special patterns, they get parsed nicely
- Different types of logs end up in the right Elasticsearch indices