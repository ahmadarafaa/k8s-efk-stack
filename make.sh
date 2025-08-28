#!/bin/bash
set -e

ELASTICSEARCH_USERNAME=${ELASTICSEARCH_USERNAME:-elastic}
ELASTIC_PASSWORD=${ELASTIC_PASSWORD:-changeme}

case "$1" in
  up)
    echo "=== Checking for port conflicts ==="
    if netstat -tln | grep -q ":9200\s"; then
        echo "Port 9200 already in use. Stopping any existing containers..."
        docker compose down 2>/dev/null || true
        kind delete cluster --name efk-lab 2>/dev/null || true
        sleep 2
    fi
    
    echo "=== Starting Elasticsearch + Kibana ==="
    docker compose up -d
    
    echo "=== Creating kind cluster ==="
    kind create cluster --config kind-config.yaml --name efk-lab
    
    echo "=== Waiting for Elasticsearch to be ready ==="
    sleep 30
    
    echo "=== Testing connectivity from kind cluster ==="
    # Test connectivity method A: host.docker.internal
    if kubectl run test-connectivity --rm -i --restart=Never --image=busybox -- wget -qO- --timeout=5 http://host.docker.internal:9200 2>/dev/null | grep -q "cluster_name"; then
      echo "Using host.docker.internal connectivity"
      ES_HOST="http://host.docker.internal:9200"
    else
      echo "Fallback: Using container IP connectivity"
      ES_CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker compose ps -q elasticsearch))
      
      # Create headless service and endpoints
      kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: external-elasticsearch
  namespace: kube-system
spec:
  ports:
  - port: 9200
    targetPort: 9200
  clusterIP: None
---
apiVersion: v1
kind: Endpoints
metadata:
  name: external-elasticsearch
  namespace: kube-system
subsets:
- addresses:
  - ip: ${ES_CONTAINER_IP}
  ports:
  - port: 9200
EOF
      ES_HOST="http://external-elasticsearch.kube-system.svc.cluster.local:9200"
    fi
    
    echo "=== Patching Fluentd configuration ==="
    # Create patched configmap
    sed "s|host 10.0.0.180|host ${ES_HOST#http://}|g; s|port 9200|port 9200|g; s|user elastic|user ${ELASTICSEARCH_USERNAME}|g; s|password JlhRQbkK=ljsQZ_imzXV|password ${ELASTIC_PASSWORD}|g; s|scheme https|scheme http|g; s|ssl_verify false|ssl_verify false|g; s|index_name auditor-test|index_name k8s-logs|g" fluentd-bit-configmap-working.yaml > fluentd-configmap-local.yaml
    
    echo "=== Deploying logging namespace ==="
    kubectl create namespace logging --dry-run=client -o yaml | kubectl apply -f -
    
    echo "=== Deploying Fluentd ==="
    kubectl apply -f fluentd-configmap-local.yaml
    kubectl apply -f fluentd-daemonset.yaml
    
    echo "=== Deploying log generator ==="
    kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: log-generator
  namespace: logging
spec:
  replicas: 1
  selector:
    matchLabels:
      app: log-generator
  template:
    metadata:
      labels:
        app: log-generator
    spec:
      containers:
      - name: generator
        image: busybox:latest
        command: ["/bin/sh"]
        args:
        - -c
        - |
          counter=1
          while true; do
            echo "[AUDIT] Log entry #\$counter - timestamp: \$(date)"
            echo "Regular log entry #\$counter"
            counter=\$((counter + 1))
            sleep 5
          done
EOF
    
    echo "=== Setup complete ==="
    echo "Elasticsearch: http://localhost:9200 (${ELASTICSEARCH_USERNAME}:${ELASTIC_PASSWORD})"
    echo "Kibana: http://localhost:5601"
    echo "Wait 1-2 minutes for logs to appear, then run: ./make.sh status"
    ;;
    
  status)
    echo "=== Elasticsearch status ==="
    curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTIC_PASSWORD} http://localhost:9200 | grep cluster_name || echo "ES not ready"
    
    echo -e "\n=== Kibana status ==="
    curl -s http://localhost:5601/api/status | grep -o '"level":"[^"]*"' || echo "Kibana not ready"
    
    echo -e "\n=== Kubernetes pods ==="
    kubectl get pods -A
    
    echo -e "\n=== Elasticsearch indices ==="
    curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTIC_PASSWORD} 'http://localhost:9200/_cat/indices?v' | grep k8s-logs || echo "No k8s-logs index yet"
    
    echo -e "\n=== Sample logs ==="
    curl -s -u ${ELASTICSEARCH_USERNAME}:${ELASTIC_PASSWORD} 'http://localhost:9200/k8s-logs/_search?size=3&sort=@timestamp:desc' | grep -o '"log":"[^"]*"' | head -3 || echo "No logs yet"
    ;;
    
  down)
    echo "=== Cleaning up external service ==="
    kubectl delete service external-elasticsearch -n kube-system --ignore-not-found=true
    kubectl delete endpoints external-elasticsearch -n kube-system --ignore-not-found=true
    
    echo "=== Stopping compose stack ==="
    docker compose down -v
    
    echo "=== Deleting kind cluster ==="
    kind delete cluster --name efk-lab
    
    echo "=== Cleanup complete ==="
    ;;
    
  *)
    echo "Usage: $0 {up|status|down}"
    exit 1
    ;;
esac