#!/usr/bin/env bash
# =============================================================================
# server-stats.sh — Análise de Performance do Servidor
# Autor: Diêgo D'mitry
# Descrição: Coleta e exibe estatísticas básicas de performance do servidor.
# Uso: bash server-stats.sh
# =============================================================================

# --- CONFIGURAÇÃO DE CORES (para deixar o output mais legível) ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- FUNÇÃO: Imprime um separador visual ---
separator() {
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# --- FUNÇÃO: Imprime o cabeçalho de cada seção ---
section() {
  echo ""
  separator
  echo -e "${BOLD}${YELLOW}  $1${RESET}"
  separator
}

# =============================================================================
# CABEÇALHO DO SCRIPT
# =============================================================================
clear
echo -e "${BOLD}${GREEN}"
echo "  ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗     ███████╗████████╗ █████╗ ████████╗███████╗"
echo "  ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗    ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝"
echo "  ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝    ███████╗   ██║   ███████║   ██║   ███████╗"
echo "  ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗    ╚════██║   ██║   ██╔══██║   ██║   ╚════██║"
echo "  ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║    ███████║   ██║   ██║  ██║   ██║   ███████║"
echo "  ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝"
echo -e "${RESET}"
echo -e "  ${BOLD}Relatório gerado em:${RESET} $(date '+%d/%m/%Y às %H:%M:%S')"
echo -e "  ${BOLD}Hostname:${RESET}           $(hostname)"

# =============================================================================
# SEÇÃO 1 — INFORMAÇÕES DO SISTEMA (Stretch Goal)
# =============================================================================
section "🖥️  INFORMAÇÕES DO SISTEMA"

# uname -r → versão do kernel
# uname -m → arquitetura (x86_64, arm64, etc.)
# lsb_release → distribuição Linux (Ubuntu, Debian, etc.)
# Se lsb_release não existir, lê /etc/os-release como fallback
if command -v lsb_release &>/dev/null; then
  OS=$(lsb_release -d | awk -F: '{print $2}' | xargs)
else
  OS=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
fi

KERNEL=$(uname -r)
ARCH=$(uname -m)

# uptime -p → formato legível (ex: "up 2 days, 3 hours, 15 minutes")
UPTIME=$(uptime -p 2>/dev/null || uptime | awk -F'( up |,  [0-9]+ user)' '{print $2}')

# /proc/loadavg → carga média do sistema nos últimos 1, 5 e 15 minutos
LOAD_AVG=$(cat /proc/loadavg | awk '{print $1, $2, $3}')

echo -e "  ${BOLD}Sistema Operacional:${RESET}  $OS"
echo -e "  ${BOLD}Kernel:${RESET}               $KERNEL ($ARCH)"
echo -e "  ${BOLD}Uptime:${RESET}               $UPTIME"
echo -e "  ${BOLD}Load Average:${RESET}         $LOAD_AVG  (1min / 5min / 15min)"

# =============================================================================
# SEÇÃO 2 — USO DE CPU
# =============================================================================
section "⚡ USO DE CPU"

# top -bn1 → roda o top uma vez (-n1) em modo não-interativo (batch: -b)
# grep "Cpu(s)" → pega a linha com os stats de CPU
# awk → extrai o % idle e calcula o uso: 100 - idle
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | tr -d '%,')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc 2>/dev/null || awk "BEGIN {printf \"%.1f\", 100 - $CPU_IDLE}")

# Coloriza baseado no nível de uso
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
  COLOR=$RED
elif (( $(echo "$CPU_USAGE > 50" | bc -l) )); then
  COLOR=$YELLOW
else
  COLOR=$GREEN
fi

echo -e "  ${BOLD}Uso Total de CPU:${RESET}  ${COLOR}${CPU_USAGE}%${RESET}"

# Número de CPUs disponíveis
CPU_COUNT=$(nproc)
echo -e "  ${BOLD}Núcleos de CPU:${RESET}    $CPU_COUNT"

# =============================================================================
# SEÇÃO 3 — USO DE MEMÓRIA
# =============================================================================
section "🧠 USO DE MEMÓRIA (RAM)"

# free -m → exibe memória em megabytes
# A saída tem o formato:
#        total    used    free  shared  buff/cache  available
# Mem:   XXXXX   XXXXX   XXXX   XXXX   XXXXX       XXXXX

MEM_TOTAL=$(free -m | awk 'NR==2 {print $2}')
MEM_USED=$(free -m  | awk 'NR==2 {print $3}')
MEM_FREE=$(free -m  | awk 'NR==2 {print $4}')
MEM_AVAIL=$(free -m | awk 'NR==2 {print $7}')  # available = free + buff/cache liberável

# Calcula percentual de uso
MEM_PCT=$(awk "BEGIN {printf \"%.1f\", ($MEM_USED / $MEM_TOTAL) * 100}")

if (( $(echo "$MEM_PCT > 80" | bc -l) )); then
  COLOR=$RED
elif (( $(echo "$MEM_PCT > 60" | bc -l) )); then
  COLOR=$YELLOW
else
  COLOR=$GREEN
fi

echo -e "  ${BOLD}Total:${RESET}        ${MEM_TOTAL} MB"
echo -e "  ${BOLD}Usado:${RESET}        ${COLOR}${MEM_USED} MB (${MEM_PCT}%)${RESET}"
echo -e "  ${BOLD}Livre:${RESET}        ${MEM_FREE} MB"
echo -e "  ${BOLD}Disponível:${RESET}   ${MEM_AVAIL} MB  ${CYAN}(inclui cache liberável)${RESET}"

# Memória SWAP
SWAP_TOTAL=$(free -m | awk 'NR==3 {print $2}')
SWAP_USED=$(free -m  | awk 'NR==3 {print $3}')

if [ "$SWAP_TOTAL" -gt 0 ]; then
  SWAP_PCT=$(awk "BEGIN {printf \"%.1f\", ($SWAP_USED / $SWAP_TOTAL) * 100}")
  echo -e "\n  ${BOLD}SWAP Total:${RESET}   ${SWAP_TOTAL} MB"
  echo -e "  ${BOLD}SWAP Usado:${RESET}   ${SWAP_USED} MB (${SWAP_PCT}%)"
else
  echo -e "\n  ${BOLD}SWAP:${RESET}         Não configurado"
fi

# =============================================================================
# SEÇÃO 4 — USO DE DISCO
# =============================================================================
section "💾 USO DE DISCO"

# df -h → disk free em formato human-readable
# -x tmpfs -x devtmpfs → ignora sistemas de arquivos virtuais (tmpfs, devtmpfs)
# --output=source,size,used,avail,pcent,target → colunas que queremos

echo -e "  ${BOLD}$(printf '%-25s %-8s %-8s %-8s %-8s %s' 'Dispositivo' 'Total' 'Usado' 'Livre' 'Uso%' 'Montagem')${RESET}"
separator

df -h -x tmpfs -x devtmpfs 2>/dev/null | tail -n +2 | while IFS= read -r line; do
  # Extrai o percentual para colorir
  PCT=$(echo "$line" | awk '{print $5}' | tr -d '%')
  DEVICE=$(echo "$line"  | awk '{print $1}')
  SIZE=$(echo "$line"    | awk '{print $2}')
  USED=$(echo "$line"    | awk '{print $3}')
  AVAIL=$(echo "$line"   | awk '{print $4}')
  MOUNT=$(echo "$line"   | awk '{print $6}')

  if [ "$PCT" -gt 90 ] 2>/dev/null; then
    COLOR=$RED
  elif [ "$PCT" -gt 70 ] 2>/dev/null; then
    COLOR=$YELLOW
  else
    COLOR=$GREEN
  fi

  printf "  %-25s %-8s %-8s %-8s ${COLOR}%-8s${RESET} %s\n" \
    "$DEVICE" "$SIZE" "$USED" "$AVAIL" "${PCT}%" "$MOUNT"
done

# =============================================================================
# SEÇÃO 5 — TOP 5 PROCESSOS POR CPU
# =============================================================================
section "🔥 TOP 5 PROCESSOS — USO DE CPU"

# ps aux → lista todos os processos com stats
# sort -rk3 → ordena pelo campo 3 (%CPU) em ordem decrescente
# head -6 → pega as 6 primeiras linhas (1 header + 5 processos)
# --no-headers → remove o cabeçalho nativo do ps para reformatar

echo -e "  ${BOLD}$(printf '%-8s %-8s %-8s %s' 'PID' '%CPU' '%MEM' 'COMANDO')${RESET}"
separator

ps aux --no-headers | sort -rk3 | head -5 | \
  awk '{printf "  %-8s %-8s %-8s %s\n", $2, $3, $4, $11}'

# =============================================================================
# SEÇÃO 6 — TOP 5 PROCESSOS POR MEMÓRIA
# =============================================================================
section "💡 TOP 5 PROCESSOS — USO DE MEMÓRIA"

# Mesma lógica, mas sort -rk4 ordena pelo campo 4 (%MEM)
echo -e "  ${BOLD}$(printf '%-8s %-8s %-8s %s' 'PID' '%CPU' '%MEM' 'COMANDO')${RESET}"
separator

ps aux --no-headers | sort -rk4 | head -5 | \
  awk '{printf "  %-8s %-8s %-8s %s\n", $2, $3, $4, $11}'

# =============================================================================
# SEÇÃO 7 — USUÁRIOS LOGADOS (Stretch Goal)
# =============================================================================
section "👤 USUÁRIOS LOGADOS"

# who → lista usuários logados no momento
LOGGED_USERS=$(who | wc -l)
echo -e "  ${BOLD}Total de sessões ativas:${RESET}  $LOGGED_USERS"
echo ""

if [ "$LOGGED_USERS" -gt 0 ]; then
  echo -e "  ${BOLD}$(printf '%-15s %-10s %-20s %s' 'USUÁRIO' 'TERMINAL' 'DATA/HORA' 'IP/HOST')${RESET}"
  separator
  who | awk '{printf "  %-15s %-10s %-20s %s\n", $1, $2, $3" "$4, $5}'
fi

# =============================================================================
# SEÇÃO 8 — TENTATIVAS DE LOGIN COM FALHA (Stretch Goal)
# =============================================================================
section "🚨 TENTATIVAS DE LOGIN COM FALHA (últimas 24h)"

# journalctl → lê o systemd journal (logs do sistema)
# --since "24 hours ago" → filtra últimas 24h
# grep "Failed password" → filtra tentativas falhas de SSH
# Se journalctl não estiver disponível, tenta /var/log/auth.log

FAILED_COUNT=0

if command -v journalctl &>/dev/null; then
  # Sistemas com systemd (Ubuntu 16+, CentOS 7+, Debian 8+)
  FAILED_COUNT=$(journalctl --since "24 hours ago" 2>/dev/null | \
    grep -c "Failed password\|authentication failure" 2>/dev/null || echo 0)
elif [ -f /var/log/auth.log ]; then
  # Debian/Ubuntu sem journalctl
  FAILED_COUNT=$(grep "Failed password\|authentication failure" /var/log/auth.log 2>/dev/null | wc -l)
elif [ -f /var/log/secure ]; then
  # CentOS/RHEL
  FAILED_COUNT=$(grep "Failed password\|authentication failure" /var/log/secure 2>/dev/null | wc -l)
fi

if [ "$FAILED_COUNT" -gt 50 ]; then
  COLOR=$RED
elif [ "$FAILED_COUNT" -gt 10 ]; then
  COLOR=$YELLOW
else
  COLOR=$GREEN
fi

echo -e "  ${BOLD}Tentativas com falha:${RESET}  ${COLOR}${FAILED_COUNT}${RESET}"
[ "$FAILED_COUNT" -gt 10 ] && echo -e "  ${RED}⚠️  Atenção: número elevado de falhas! Verifique possível brute-force.${RESET}"

# =============================================================================
# RODAPÉ
# =============================================================================
echo ""
separator
echo -e "  ${BOLD}${GREEN}✅ Relatório concluído.${RESET}  Servidor: $(hostname -f 2>/dev/null || hostname)"
separator
echo ""