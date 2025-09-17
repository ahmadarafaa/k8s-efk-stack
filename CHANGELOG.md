# What's Changed

I'll keep track of the important stuff here so you know what's new.

## v1.0.0 - September 17, 2024

Production-ready release with complete EFK stack implementation.

### Production Features
- Complete Kubernetes EFK stack with Fluentd DaemonSet architecture
- Multiple production-ready Fluentd configurations for different deployment scenarios
- RBAC and service account security configurations
- Custom log pattern detection and structured field extraction
- Multi-namespace support with flexible indexing strategies
- Comprehensive documentation and architecture diagrams
- GitHub community standards (issue templates, contributing guidelines, security policy)

### Configuration Options
- `fluentd-minimal-basic-config` - Simple cluster-wide log collection
- `fluentd-single-namespace-alert-config` - Single namespace with alert processing
- `fluentd-multi-namespace-centralized-alert-config` - Multi-namespace with centralized alerts
- `fluentd-multi-namespace-per-ns-alert-config` - Per-namespace alert routing
- `fluentd-all-except-system-config` - Cluster-wide collection excluding system namespaces
- `fluentd-environment-based-config` - Environment-specific log routing

### Requirements
- Kubernetes 1.16+
- Elasticsearch cluster
- kubectl configured

### Documentation
- Professional README with SEO optimization
- Architecture diagrams and flow documentation
- Single and multi-namespace deployment examples
- Security considerations and best practices

## v0.1.0 - Initial Development

### The Good Stuff
- Got the whole EFK stack working on Kubernetes
- Made several Fluentd configs for different situations:
  - Simple one that just collects everything
  - Single namespace setup for focused deployments
  - Multi-namespace configs with different routing strategies
  - Time-based indexing for analytics folks
  - Cluster-wide collection (but skips system namespaces)
- Set up proper RBAC so security people won't yell at you
- DaemonSet that actually works
- Custom log parsing that can handle your weird log formats
- Different ways to organize your logs in Elasticsearch
- Wrote docs that hopefully make sense
- MIT license so you can actually use this
- Templates for bug reports and feature requests

### What Works
- Kubernetes 1.16 and up
- Standard Fluentd image (v1-debian-elasticsearch)
- Talks to Elasticsearch nicely
- Multiple ways to route your logs