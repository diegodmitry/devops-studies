#!/usr/bin/env bash

# =============================================================================
# log-archive-tool.sh — Ferramenta de Arquivamento de Logs
# Autor: Diêgo D'mitry
# Descrição: Compacta logs antigos para economizar espaço em disco.
# Uso: bash log-archive-tool.sh /caminho/para/logs
# =============================================================================

# Verifica se o caminho dos logs foi fornecido
if [ -z "$1" ]; then
    echo "Uso: bash log-archive-tool.sh /caminho/para/logs"
    exit 1
fi
LOG_DIR="$1"

# Verifica se o diretório existe
if [ ! -d "$LOG_DIR" ]; then
    echo "Erro: O diretório $LOG_DIR não existe."
    exit 1
fi

# Cria o diretório de arquivamento se não existir
mkdir -p "$HOME/logs_archive"

# Define o nome do arquivo de arquivamento com base na data atual(ano-mês-dia_hora-minuto-segundo), localizado no diretório logs_archive dentro do Home do usuário
ARCHIVE_NAME="$HOME/logs_archive/logs_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

# Compacta os arquivos de log antigos (modificados há mais de 7 dias)
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -print0 | tar -czf "$ARCHIVE_NAME" --null -T -

# Verifica se o processo de arquivamento foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Logs antigos foram arquivados com sucesso em $ARCHIVE_NAME."
    # Registra a criação do arquivo de arquivamento em um log de atividades
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Arquivo criado: $(basename $ARCHIVE_NAME)" >> "$HOME/logs_archive/archive_log.txt"
else
    echo "Erro: Falha ao arquivar os logs."
    exit 1
fi
