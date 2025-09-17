---
name: Bug report
about: Something's not working right? Let me know!
title: '[BUG] '
labels: bug
assignees: ''
---

**What's going wrong?**
Tell me what's happening that shouldn't be happening.

**How can I see it myself?**
Walk me through the steps:
1. I deployed this config: '...'
2. Then I ran this command: '...'
3. And this error showed up: '...'

**What did you expect instead?**
What should have happened?

**Your setup:**
- Kubernetes version: [like 1.24.0]
- Fluentd image: [like v1.16-debian-elasticsearch]
- Elasticsearch version: [like 7.17.0]
- Which config are you using: [like fluentd-single-namespace-alert-config]

**Error logs**
Paste any error messages you're seeing:
```
kubectl logs -l k8s-app=fluentd-logging -n logging
```

**Anything else?**
Any other details that might help me figure this out?