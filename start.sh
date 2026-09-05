#!/bin/bash

set -e

mkdir -p /home/ubuntu/.ssh

if [ -z "$SSH_PUBLIC_KEY" ]; then
    echo "ERROR: SSH_PUBLIC_KEY is not set"
    exit 1
fi

echo "$SSH_PUBLIC_KEY" > /home/ubuntu/.ssh/authorized_keys

chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys

echo "Starting SSH..."

exec /usr/sbin/sshd -D -e
