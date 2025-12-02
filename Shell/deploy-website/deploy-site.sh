#!/bin/bash

# Configuration - UPDATE THESE!
REPO_DIR="/home/youruser/my-react-site"  # Your git repo location
NGINX_DIR="/var/www/html"                # Where nginx serves from
BUILD_DIR="build"                         # or "dist" for Vite/other bundlers
BRANCH="main"                             # or "master"

# Go to repo directory
cd $REPO_DIR || exit 1

# Fetch latest changes from remote
git fetch origin

# Get current local and remote commit hashes
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/$BRANCH)

# Only build if there are new changes
if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[$(date)] New changes detected, deploying..."
    
    # Pull latest changes
    git pull origin $BRANCH
    
    # Install/update dependencies (only if package.json changed)
    if git diff HEAD@{1} HEAD --name-only | grep -q "package.json"; then
        echo "[$(date)] package.json changed, running npm install..."
        npm install
    fi
    
    # Build the site
    echo "[$(date)] Building..."
    npm run build
    
    # Copy to nginx directory
    echo "[$(date)] Copying files to nginx..."
    sudo rsync -av --delete $REPO_DIR/$BUILD_DIR/ $NGINX_DIR/
    
    echo "[$(date)] ✓ Deployment complete!"
else
    echo "[$(date)] No changes detected"
fi
