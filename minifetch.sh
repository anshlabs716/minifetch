```bash
#!/usr/bin/env bash
# ==============================================================================
# minifetch.sh - Ultra-fast, zero-dependency system fetch for Linux & Termux
# ==============================================================================

# ANSI Colors
C_CYAN="\033[1;36m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_BLUE="\033[1;34m"
C_MAGENTA="\033[1;35m"
C_RESET="\033[0m"
C_BOLD="\033[1m"

# 1. User and Hostname
USER_NAME="${USER:-$(whoami)}"
if command -v hostname >/dev/null 2>&1; then
    HOST_NAME="$(hostname)"
else
    HOST_NAME="localhost"
fi

# 2. Kernel & OS Info (Handles Termux vs Standard Linux)
KERNEL="$(uname -r)"
ARCH="$(uname -m)"
OS_NAME="Unix-like"

if [ -d "$PREFIX" ] && [ -n "$TERMUX_VERSION" ]; then
    OS_NAME="Termux (Android)"
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="${PRETTY_NAME:-$NAME}"
fi

# 3. Uptime Calculation (Cross-platform fallback)
UPTIME="Unknown"
if [ -f /proc/uptime ]; then
    read -r uptime_seconds _ < /proc/uptime
    uptime_seconds=${uptime_seconds%.*}
    up_hours=$(( uptime_seconds / 3600 ))
    up_mins=$(( (uptime_seconds % 3600) / 60 ))
    UPTIME="${up_hours}h ${up_mins}m"
elif command -v uptime >/dev/null 2>&1; then
    UPTIME="$(uptime -p 2>/dev/null || uptime | awk -F'(, +)|(, *[0-9]+ +user)' '{print $2}')"
fi

# 4. RAM Calculation (Termux compatible via free/proc)
RAM="Unknown"
if [ -f /proc/meminfo ]; then
    total_kb=0
    avail_kb=0
    while read -r key val _; do
        case "$key" in
            MemTotal:) total_kb=$val ;;
            MemAvailable:) avail_kb=$val ;;
            MemFree:) [ "$avail_kb" -eq 0 ] && avail_kb=$val ;; # fallback if no MemAvailable
        esac
    done < /proc/meminfo
    
    if [ "$total_kb" -gt 0 ]; then
        total_mb=$(( total_kb / 1024 ))
        used_mb=$(( (total_kb - avail_kb) / 1024 ))
        RAM="${used_mb} MiB / ${total_mb} MiB"
    fi
elif command -v free >/dev/null 2>&1; then
    RAM="$(free -m | awk '/Mem:/ {print $3 " MiB / " $2 " MiB"}')"
fi

# 5. CPU Model (Termux vs Linux /proc/cpuinfo or sysctl)
CPU="Generic CPU"
if [ -f /proc/cpuinfo ]; then
    while read -r line; do
        if [[ "$line" == model\ name* ]] || [[ "$line" == Hardware* ]] || [[ "$line" == Processor* ]]; then
            CPU="${line#*: }"
            break
        fi
    done < /proc/cpuinfo
elif command -v sysctl >/dev/null 2>&1; then
    CPU="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || sysctl -n hw.model 2>/dev/null || echo "Generic CPU")"
fi

# --- Output Layout ---
printf "\n"
printf "  ${C_CYAN}   /\\   ${C_RESET}   ${C_BOLD}%s${C_RESET}@${C_BOLD}%s${C_RESET}\n" "$USER_NAME" "$HOST_NAME"
printf "  ${C_CYAN}  /  \\  ${C_RESET}   --------------------\n"
printf "  ${C_CYAN} / /\\ \\ ${C_RESET}   ${C_GREEN}OS:     ${C_RESET}%s\n" "$OS_NAME"
printf "  ${C_CYAN} / /  \\ \\${C_RESET}   ${C_YELLOW}Kernel: ${C_RESET}%s (%s)\n" "$KERNEL" "$ARCH"
printf "  ${C_CYAN}/_/__  \\_\\${C_RESET}  ${C_BLUE}Uptime: ${C_RESET}%s\n" "$UPTIME"
printf "            ${C_MAGENTA}CPU:    ${C_RESET}%s\n" "$CPU"
printf "            ${C_CYAN}RAM:    ${C_RESET}%s\n" "$RAM"

# Color Palette bar
printf "\n            "
printf "\033[40m   \033[41m   \033[42m   \033[43m   \033[44m   \033[45m   \033[46m   \033[47m   \033[0m\n\n"

```
