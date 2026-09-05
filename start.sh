#!/bin/bash

set -e

mkdir -p /home/ubuntu/.ssh
mkdir -p /var/run/tailscale
mkdir -p /var/lib/tailscale

if [ -z "$SSH_PUBLIC_KEY" ]; then
    echo "ERROR: SSH_PUBLIC_KEY is not set"
    exit 1
fi

echo "$SSH_PUBLIC_KEY" > /home/ubuntu/.ssh/authorized_keys

chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys

echo "Starting Tailscale..."

tailscaled \
    --tun=userspace-networking \
    --state=/var/lib/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock &

sleep 3

if [ -n "$TAILSCALE_AUTH_KEY" ]; then
    tailscale --socket=/var/run/tailscale/tailscaled.sock up \
        --auth-key="$TAILSCALE_AUTH_KEY" \
        --advertise-exit-node \
        --hostname=railway-exit-node
else
    echo "WARNING: TAILSCALE_AUTH_KEY is not set"
fi

echo "Starting SSH..."

exec /usr/sbin/sshd -D -e
