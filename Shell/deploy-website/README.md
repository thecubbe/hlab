## Step 1: Create the deployment script

```bash
nano ~/deploy-site.sh
```

Paste this (adjust the paths for your setup):

```bash
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
```

## Step 2: Make it executable

```bash
chmod +x ~/deploy-site.sh
```

## Step 3: Test the script manually

```bash
~/deploy-site.sh
```

If you get a password prompt for `sudo rsync`, you need to fix that:

```bash
sudo visudo
```

Add this line at the end (replace `youruser` with your actual username):
```
youruser ALL=(ALL) NOPASSWD: /usr/bin/rsync
```

Save and exit (Ctrl+X, then Y, then Enter).

## Step 4: Set up the cron job

Open crontab:
```bash
crontab -e
```

Add this line (checks every 5 minutes):
```
*/5 * * * * /home/youruser/deploy-site.sh >> /home/youruser/deploy.log 2>&1
```

Or if you want every 10 minutes:
```
*/10 * * * * /home/youruser/deploy-site.sh >> /home/youruser/deploy.log 2>&1
```

Save and exit.

## Step 5: Verify cron job is active

```bash
crontab -l
```

You should see your job listed.

## Step 6: Monitor it working

Watch the log file:
```bash
tail -f ~/deploy.log
```

Or check recent entries:
```bash
tail -20 ~/deploy.log
```

---

## Quick troubleshooting:

**If npm commands aren't found in cron:**
Add this to the top of your script:
```bash
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.nvm/versions/node/v18.x.x/bin"
```

**To manually trigger a deployment:**
```bash
~/deploy-site.sh
```

That's it! Push something to your repo and within 5-10 minutes it should auto-deploy. Want to test it now?
