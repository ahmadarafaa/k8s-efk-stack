# EFK Stack Architecture

This diagram shows how logs flow from Kubernetes applications through Fluentd to Elasticsearch.

## Architecture Overview

```
+======================================================================================+
|                            🔵 Kubernetes Cluster                                     |
+======================================================================================+
|                                                                                      |
|   +-----------------------+ +-----------------------+ +-----------------------+      |
|   |        Node 1         | |        Node 2         | |        Node 3         |      |
|   |                       | |                       | |                       |      |
|   |     [App Pods]        | |     [App Pods]        | |     [App Pods]        |      |
|   |          ↓            | |          ↓            | |          ↓            |      |
|   |  /var/log/containers/ | |  /var/log/containers/ | |  /var/log/containers/ |      |
|   |          ↓            | |          ↓            | |          ↓            |      |
|   |     [Fluentd]         | |     [Fluentd]         | |     [Fluentd]         |      |
|   |     DaemonSet         | |     DaemonSet         | |     DaemonSet         |      |
|   +-----------------------+ +-----------------------+ +-----------------------+      |
|                                                                                      |
|                📋 Namespaces: production, staging, development                       |
+======================================================================================+
                                      |
                                      ↓
                         +----------------------------+
                         |      🔶 ConfigMap          |
                         |   fluentd-config.yaml      |
                         +----------------------------+
                                      |
                                      ↓ (logs)

+======================================================================================+
|                          🔷 Elasticsearch Cluster                                    |
+======================================================================================+
|                                                                                      |
|     +--------------+      +--------------+      +--------------+                     |
|     |  (app-logs)  |      | (alert-logs) |      | (system-logs)|                     |
|     |      💾      |      |      💾      |      |      💾      |                     |
|     +--------------+      +--------------+      +--------------+                     |
|                                                                                      |
+======================================================================================+
```

## Key Components

- **🔵 Kubernetes Cluster**: Contains multiple nodes running applications
- **App Pods**: Generate logs that need to be collected
- **📁 /var/log/containers/**: Where Kubernetes stores container log files
- **Fluentd DaemonSet**: Runs on every node to collect logs
- **🔶 ConfigMap**: Provides Fluentd configuration and parsing rules
- **🔷 Elasticsearch**: Stores processed logs in different indices

## Log Flow Process

1. **Application pods** generate logs
2. **Kubernetes** automatically stores these logs in `/var/log/containers/` on each node
3. **Fluentd DaemonSet** (running on every node) reads these log files
4. **ConfigMap** provides Fluentd with parsing and routing configuration
5. **Fluentd** processes the logs and routes them to appropriate **Elasticsearch indices**

## Index Strategy

- **app-logs**: Regular application logs
- **alert-logs**: Special alert/warning logs
- **system-logs**: System and infrastructure logs

This architecture ensures that every container's logs are collected regardless of which node they run on, and logs are properly parsed and organized in Elasticsearch for easy searching and analysis.