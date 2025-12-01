# deployed locally at predifined location | chmod +x file-name.sh
#!/bin/bash

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Git-sync hook triggered - restarting traefik-hlab"

# Use Docker socket directly to restart the container
RESPONSE=$(curl -v -X POST --unix-socket /var/run/docker.sock \
  http://localhost/containers/traefik-hlab/restart 2>&1)

CURL_EXIT=$?

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Curl exit code: $CURL_EXIT"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Response: $RESPONSE"

if [ $CURL_EXIT -eq 0 ]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Successfully restarted traefik-hlab"
    exit 0
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Failed to restart traefik-hlab"
    exit 1
fi
