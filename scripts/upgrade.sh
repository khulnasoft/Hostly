#!/bin/bash
## Do not modify this file. You will lose the ability to autoupdate!

VERSION="13"
CDN="https://cdn.khulnasoft.com/hostly"
LATEST_IMAGE=${1:-latest}
LATEST_HELPER_VERSION=${2:-latest}

DATE=$(date +%Y-%m-%d-%H-%M-%S)
LOGFILE="/data/hostly/source/upgrade-${DATE}.log"

curl -fsSL $CDN/docker-compose.yml -o /data/hostly/source/docker-compose.yml
curl -fsSL $CDN/docker-compose.prod.yml -o /data/hostly/source/docker-compose.prod.yml
curl -fsSL $CDN/.env.production -o /data/hostly/source/.env.production

# Merge .env and .env.production. New values will be added to .env
awk -F '=' '!seen[$1]++' /data/hostly/source/.env /data/hostly/source/.env.production  > /data/hostly/source/.env.tmp && mv /data/hostly/source/.env.tmp /data/hostly/source/.env
# Check if PUSHER_APP_ID or PUSHER_APP_KEY or PUSHER_APP_SECRET is empty in /data/hostly/source/.env
if grep -q "PUSHER_APP_ID=$" /data/hostly/source/.env; then
    sed -i "s|PUSHER_APP_ID=.*|PUSHER_APP_ID=$(openssl rand -hex 32)|g" /data/hostly/source/.env
fi

if grep -q "PUSHER_APP_KEY=$" /data/hostly/source/.env; then
    sed -i "s|PUSHER_APP_KEY=.*|PUSHER_APP_KEY=$(openssl rand -hex 32)|g" /data/hostly/source/.env
fi

if grep -q "PUSHER_APP_SECRET=$" /data/hostly/source/.env; then
    sed -i "s|PUSHER_APP_SECRET=.*|PUSHER_APP_SECRET=$(openssl rand -hex 32)|g" /data/hostly/source/.env
fi

# Make sure hostly network exists
# It is created when starting Hostly with docker compose
docker network create --attachable hostly 2>/dev/null
# docker network create --attachable --driver=overlay hostly-overlay 2>/dev/null

if [ -f /data/hostly/source/docker-compose.custom.yml ]; then
    echo "docker-compose.custom.yml detected." >> $LOGFILE
    docker run -v /data/hostly/source:/data/hostly/source -v /var/run/docker.sock:/var/run/docker.sock --rm ghcr.io/khulnasoft/hostly-helper:${LATEST_HELPER_VERSION} bash -c "LATEST_IMAGE=${LATEST_IMAGE} docker compose --env-file /data/hostly/source/.env -f /data/hostly/source/docker-compose.yml -f /data/hostly/source/docker-compose.prod.yml -f /data/hostly/source/docker-compose.custom.yml up -d --remove-orphans --force-recreate --wait --wait-timeout 60" >> $LOGFILE 2>&1
else
    docker run -v /data/hostly/source:/data/hostly/source -v /var/run/docker.sock:/var/run/docker.sock --rm ghcr.io/khulnasoft/hostly-helper:${LATEST_HELPER_VERSION} bash -c "LATEST_IMAGE=${LATEST_IMAGE} docker compose --env-file /data/hostly/source/.env -f /data/hostly/source/docker-compose.yml -f /data/hostly/source/docker-compose.prod.yml up -d --remove-orphans --force-recreate --wait --wait-timeout 60" >> $LOGFILE 2>&1
fi
