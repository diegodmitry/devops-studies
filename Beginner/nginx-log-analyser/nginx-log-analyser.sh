#!/usr/bin/env bash
# =============================================================================
# nginx-log-analyser.sh — Ferramenta de Análise de Logs do Nginx
# Autor: Diêgo D'mitry
# Descrição: Analisa logs do Nginx para extrair informações úteis.
# Uso: bash nginx-log-analyser.sh /caminho/para/logs
# =============================================================================

# Verificar se o arquivo dos logs foi fornecido
if [ -z "$1" ]; then
    echo "Use: bash $0 arquivo_de_logs"
    exit 1
fi

LOG_FILE="$1"

echo "Top 5 Endereços IP mais requisitados:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'
echo ""

echo "Top 5 Caminhos mais requisitados:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'
echo ""

echo "Top 5 Códigos de Status de Resposta:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'
echo ""

echo "Top 5 User Agents:"
awk -F\" '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'
echo ""