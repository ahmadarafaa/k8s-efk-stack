#!/bin/bash

# Configure Elasticsearch ILM retention policy
# Usage: ./configure-retention.sh <retention_days>
# Example: ./configure-retention.sh 30

RETENTION_DAYS=${1:-7}
ES_HOST=${ES_HOST:-172.21.0.1:9200}
ES_USER=${ES_USER:-elastic}
ES_PASS=${ES_PASS:-changeme}

echo "Configuring Elasticsearch ILM policy with ${RETENTION_DAYS} days retention..."

# Update the ILM policy with the specified retention period
curl -X PUT -u ${ES_USER}:${ES_PASS} "http://${ES_HOST}/_ilm/policy/kubernetes-logs-policy" \
-H "Content-Type: application/json" \
-d "{
  \"policy\": {
    \"phases\": {
      \"hot\": {
        \"actions\": {
          \"rollover\": {
            \"max_size\": \"10GB\",
            \"max_age\": \"1d\"
          }
        }
      },
      \"delete\": {
        \"min_age\": \"${RETENTION_DAYS}d\",
        \"actions\": {
          \"delete\": {}
        }
      }
    }
  }
}"

echo ""
echo "ILM policy updated successfully!"
echo "Records older than ${RETENTION_DAYS} days will be automatically deleted."

# Verify the policy
echo ""
echo "Current policy configuration:"
curl -s -u ${ES_USER}:${ES_PASS} "http://${ES_HOST}/_ilm/policy/kubernetes-logs-policy" | jq '.'