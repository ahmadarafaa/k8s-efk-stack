# Security Policy

## Supported Versions

We currently support the following versions with security updates:

| Version | Kubernetes Support | Security Support |
| ------- | ------------------ | ---------------- |
| 0.1.x   | 1.16+             | ✅ Active        |

## Reporting a Vulnerability

If you discover a security vulnerability in this EFK stack, please report it privately.

### How to Report

1. **Email**: Send details to the repository maintainer
2. **GitHub Security**: Use GitHub's private vulnerability reporting feature
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Response time**: Within 48 hours
- **Updates**: Every 72 hours until resolved
- **Credit**: Security researchers will be credited unless they prefer anonymity

### Security Best Practices

When deploying this EFK stack:

- **RBAC**: Use provided RBAC configurations - don't run with cluster-admin
- **Secrets**: Store Elasticsearch credentials in Kubernetes Secrets
- **Network**: Implement network policies to restrict pod-to-pod communication
- **Images**: Use official Fluentd images and scan for vulnerabilities
- **Updates**: Keep Kubernetes, Fluentd, and Elasticsearch versions current

### Known Security Considerations

- Fluentd DaemonSet requires access to `/var/log/containers/` on nodes
- Log data may contain sensitive information - implement log sanitization if needed
- Elasticsearch should be secured with authentication and encryption in production