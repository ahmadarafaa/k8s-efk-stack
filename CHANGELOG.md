# What's Changed

I'll keep track of the important stuff here so you know what's new.

## What's Coming Next

Working on some cool stuff for the next release!

## v0.1.0 - December 19, 2024

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