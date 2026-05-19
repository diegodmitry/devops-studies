#!/bin/bash

# =============================================================================
# deploy.sh — Deploy de Site Estático
# Autor: Diêgo D'mitry
# Descrição: Faz o deploy de um site estático para um servidor remoto.
# Uso: bash deploy.sh
# =============================================================================

set -e

SERVER_USER="root"
SERVER_IP="IP__ADDRESS"
REMOTE_PATH="/var/www/static-site"

echo "Starting deployment..."

rsync -avz --delete \
  --exclude ".git" \
  --exclude "README.md" \
  ./ ${SERVER_USER}@${SERVER_IP}:${REMOTE_PATH}/

echo "Deployment completed successfully!"
echo "Website available at: http://${SERVER_IP}"