#!/usr/bin/env bash

# =============================================================================
# log-archive-tool.sh — Ferramenta de Arquivamento de Logs
# Autor: Diêgo D'mitry
# Descrição: Create a long-running systemd service that logs to a file.
# Uso: 
# =============================================================================

while true; do
  echo "Dummy service is running..." >> /var/log/dummy-service.log
  sleep 10
done
/home/k1user/dummy-systemd-service/dummy.sh