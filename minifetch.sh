#!/usr/bin/env bash
# ==============================================================================
# minifetch.sh - Accurate distro logos & Android bugdroid with aligned output
# ==============================================================================

# ANSI Colors
C_CYAN="\033[1;36m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_BLUE="\033[1;34m"
C_MAGENTA="\033[1;35m"
C_RED="\033[1;31m"
C_RESET="\033[0m"
C_BOLD="\033[1m"

# 1. User & Hostname
USER_NAME="${USER:-$(whoami 2>/dev/null || id -un 2>/dev/null || echo "user")}"
if command -v hostname >/dev/null 2>&1; then
    HOST_NAME="$(hostname)"
elif [ -f /etc/hostname ]; then
    HOST_NAME="$(cat /etc/hostname)"
else
    HOST_NAME="localhost"
fi

# 2. Universal OS & Distro Key Detection
KERNEL="$(uname -r 2>/dev/null || echo "Unknown")"
ARCH="$(uname -m 2>/dev/null || echo "Unknown")"
UNAME_S="$(uname -s 2>/dev/null)"
OS_NAME="Linux"
DISTRO_KEY="generic"

if [ -n "$PREFIX" ] && [ -n "$TERMUX_VERSION" ]; then
    OS_NAME="Termux (Android)"
    DISTRO_KEY="android"
elif [ "$UNAME_S" = "Darwin" ]; then
    MAC_VER="$(sw_vers -productVersion 2>/dev/null || echo "")"
    OS_NAME="macOS ${MAC_VER}"
    DISTRO_KEY="mac"
elif [ "$UNAME_S" = "FreeBSD" ]; then
    OS_NAME="FreeBSD ${KERNEL}"
    DISTRO_KEY="freebsd"
elif [ "$UNAME_S" = "OpenBSD" ]; then
    OS_NAME="OpenBSD ${KERNEL}"
    DISTRO_KEY="openbsd"
elif [ "$UNAME_S" = "NetBSD" ]; then
    OS_NAME="NetBSD ${KERNEL}"
    DISTRO_KEY="netbsd"
elif echo "$UNAME_S" | grep -qi "BSD"; then
    OS_NAME="${UNAME_S} ${KERNEL}"
    DISTRO_KEY="bsd"
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="${PRETTY_NAME:-$NAME}"
    DISTRO_KEY="$(echo "${ID:-$ID_LIKE}" | tr '[:upper:]' '[:lower:]')"
elif [ -f /etc/debian_version ]; then
    OS_NAME="Debian GNU/Linux $(cat /etc/debian_version)"
    DISTRO_KEY="debian"
elif [ -f /etc/arch-release ]; then
    OS_NAME="Arch Linux"
    DISTRO_KEY="arch"
fi

# 3. Uptime Math
UPTIME="Unknown"
if [ -f /proc/uptime ]; then
    read -r uptime_seconds _ < /proc/uptime
    uptime_seconds="${uptime_seconds%%.*}"
    up_days=$(( uptime_seconds / 86400 ))
    up_hours=$(( (uptime_seconds % 86400) / 3600 ))
    up_mins=$(( (uptime_seconds % 3600) / 60 ))
    if [ "$up_days" -gt 0 ]; then
        UPTIME="${up_days}d ${up_hours}h ${up_mins}m"
    else
        UPTIME="${up_hours}h ${up_mins}m"
    fi
elif command -v uptime >/dev/null 2>&1; then
    UPTIME="$(uptime | sed -E 's/.*up ([^,]+),.*/\1/' | xargs)"
fi

# 4. Memory Detection
RAM="Unknown"
if [ -f /proc/meminfo ]; then
    total_kb=0; avail_kb=0; free_kb=0; buffers_kb=0; cached_kb=0
    while read -r key val _; do
        case "$key" in
            MemTotal:) total_kb="$val" ;;
            MemAvailable:) avail_kb="$val" ;;
            MemFree:) free_kb="$val" ;;
            Buffers:) buffers_kb="$val" ;;
            Cached:) cached_kb="$val" ;;
        esac
    done < /proc/meminfo
    [ "$avail_kb" -eq 0 ] 2>/dev/null && avail_kb=$(( free_kb + buffers_kb + cached_kb ))
    if [ "$total_kb" -gt 0 ] 2>/dev/null; then
        total_mb=$(( total_kb / 1024 ))
        used_mb=$(( (total_kb - avail_kb) / 1024 ))
        RAM="${used_mb} MiB / ${total_mb} MiB"
    fi
elif command -v free >/dev/null 2>&1; then
    RAM="$(free -m 2>/dev/null | awk '/Mem:/ {print $3 " MiB / " $2 " MiB"}')"
elif command -v sysctl >/dev/null 2>&1; then
    hw_mem="$(sysctl -n hw.physmem 2>/dev/null || sysctl -n hw.memsize 2>/dev/null || echo 0)"
    if [ "$hw_mem" -gt 0 ]; then
        total_mb=$(( hw_mem / 1024 / 1024 ))
        RAM="${total_mb} MiB Total"
    fi
fi

# 5. CPU Model Parsing
CPU="Generic CPU"
if [ -f /proc/cpuinfo ]; then
    while IFS=':' read -r key val; do
        key="$(echo "$key" | xargs)"
        case "$key" in
            model\ name|Hardware|Processor|Chip|cpu)
                if [ -n "$val" ]; then CPU="$(echo "$val" | xargs)"; break; fi ;;
        esac
    done < /proc/cpuinfo
elif command -v sysctl >/dev/null 2>&1; then
    CPU="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || sysctl -n hw.model 2>/dev/null || echo "Generic CPU")"
fi

# 6. System Info Lines
info_0="${C_BOLD}${USER_NAME}${C_RESET}@${C_BOLD}${HOST_NAME}${C_RESET}"
info_1="--------------------"
info_2="${C_GREEN}OS:     ${C_RESET}${OS_NAME}"
info_3="${C_YELLOW}Kernel: ${C_RESET}${KERNEL} (${ARCH})"
info_4="${C_BLUE}Uptime: ${C_RESET}${UPTIME}"
info_5="${C_MAGENTA}CPU:    ${C_RESET}${CPU}"
info_6="${C_CYAN}RAM:    ${C_RESET}${RAM}"
info_7=""
info_8="\033[40m   \033[41m   \033[42m   \033[43m   \033[44m   \033[45m   \033[46m   \033[47m   \033[0m"

# 7. Exact 16-character padded ASCII logos
case "$DISTRO_KEY" in
    *android*|*termux*)
        l0="${C_GREEN}     ,-.   ,-.  ${C_RESET}"
        l1="${C_GREEN}    (  o|_|o  ) ${C_RESET}"
        l2="${C_GREEN}     |_______|  ${C_RESET}"
        l3="${C_GREEN}    .|       |. ${C_RESET}"
        l4="${C_GREEN}    ||  _|_  || ${C_RESET}"
        l5="${C_GREEN}    '|_______|' ${C_RESET}"
        l6="${C_GREEN}     ~  | |  ~  ${C_RESET}"
        l7="                "
        l8="                "
        ;;
    *mac*|*darwin*)
        l0="${C_GREEN}       .:'      ${C_RESET}"
        l1="${C_GREEN}    __ :'_      ${C_RESET}"
        l2="${C_YELLOW}  .'\`_ \`-'\`__.  ${C_RESET}"
        l3="${C_RED} /  \`'  \`'    \\ ${C_RESET}"
        l4="${C_MAGENTA}:   (.  .)    : ${C_RESET}"
        l5="${C_BLUE} \\           /  ${C_RESET}"
        l6="${C_CYAN}  \`.__.---.__'  ${C_RESET}"
        l7="                "
        l8="                "
        ;;
    *arch*)
        l0="${C_CYAN}       /\\       ${C_RESET}"
        l1="${C_CYAN}      /  \\      ${C_RESET}"
        l2="${C_CYAN}     /\\   \\     ${C_RESET}"
        l3="${C_CYAN}    /      \\    ${C_RESET}"
        l4="${C_CYAN}   /   ,,   \\   ${C_RESET}"
        l5="${C_CYAN}  /   |  |  -\\  ${C_RESET}"
        l6="${C_CYAN} /_-''    ''-_\\ ${C_RESET}"
        l7="                "
        l8="                "
        ;;
    *mint*)
        l0="${C_GREEN}  ___________   ${C_RESET}"
        l1="${C_GREEN} |_  ___  ___|  ${C_RESET}"
        l2="${C_GREEN}   | |  | |     ${C_RESET}"
        l3="${C_GREEN}   | |  | |     ${C_RESET}"
        l4="${C_GREEN}  _| |__| |_    ${C_RESET}"
        l5="${C_GREEN} |__________|   ${C_RESET}"
        l6="                "
        l7="                "
        l8="                "
        ;;
    *ubuntu*)
        l0="${C_RED}         _      ${C_RESET}"
        l1="${C_RED}     ---(_)     ${C_RESET}"
        l2="${C_RED} _/  ---  \\     ${C_RESET}"
        l3="${C_RED}(_) |   |       ${C_RESET}"
        l4="${C_RED}  \\  ---  /     ${C_RESET}"
        l5="${C_RED}     ---(_)     ${C_RESET}"
        l6="                "
        l7="                "
        l8="                "
        ;;
    *debian*)
        l0="${C_RED}     _____      ${C_RESET}"
        l1="${C_RED}   /  __  \\     ${C_RESET}"
        l2="${C_RED}  |  /  |  |    ${C_RESET}"
        l3="${C_RED}  |  \\_ /  |    ${C_RESET}"
        l4="${C_RED}   \\______/     ${C_RESET}"
        l5="                "
        l6="                "
        l7="                "
        l8="                "
        ;;
    *fedora*)
        l0="${C_BLUE}      _____     ${C_RESET}"
        l1="${C_BLUE}     /   __)\\    ${C_RESET}"
        l2="${C_BLUE}    /  /  ___   ${C_RESET}"
        l3="${C_BLUE}   /  /  / __)  ${C_RESET}"
        l4="${C_BLUE}  /  (__/ /     ${C_RESET}"
        l5="${C_BLUE} (_______/      ${C_RESET}"
        l6="                "
        l7="                "
        l8="                "
        ;;
    *freebsd*|*bsd*)
        l0="${C_RED}      /\\_/\\     ${C_RESET}"
        l1="${C_RED}     ( o.o )    ${C_RESET}"
        l2="${C_RED}      > ^ <     ${C_RESET}"
        l3="${C_RED}      /| |\\     ${C_RESET}"
        l4="${C_RED}     (_|_|_)    ${C_RESET}"
        l5="                "
        l6="                "
        l7="                "
        l8="                "
        ;;
    *openbsd*)
        l0="${C_YELLOW}      ___       ${C_RESET}"
        l1="${C_YELLOW}    _/  _ \\     ${C_RESET}"
        l2="${C_YELLOW}   (o)  o  )    ${C_RESET}"
        l3="${C_YELLOW}  ====  =  ==== ${C_RESET}"
        l4="${C_YELLOW}    \\_____/     ${C_RESET}"
        l5="                "
        l6="                "
        l7="                "
        l8="                "
        ;;
    *) # Generic Linux Tux / Fallback
        l0="${C_YELLOW}     .---.      ${C_RESET}"
        l1="${C_YELLOW}    |o_o  |     ${C_RESET}"
        l2="${C_YELLOW}    |:_/  |     ${C_RESET}"
        l3="${C_YELLOW}   //   \\ \\     ${C_RESET}"
        l4="${C_YELLOW}  (|     | )    ${C_RESET}"
        l5="${C_YELLOW} /'\\_   _\`/\\    ${C_RESET}"
        l6="${C_YELLOW} \\___)=(___/    ${C_RESET}"
        l7="                "
        l8="                "
        ;;
esac

# 8. Print side-by-side with clean padding
printf "\n"
printf "  %b  %b\n" "$l0" "$info_0"
printf "  %b  %b\n" "$l1" "$info_1"
printf "  %b  %b\n" "$l2" "$info_2"
printf "  %b  %b\n" "$l3" "$info_3"
printf "  %b  %b\n" "$l4" "$info_4"
printf "  %b  %b\n" "$l5" "$info_5"
printf "  %b  %b\n" "$l6" "$info_6"
printf "  %b  %b\n" "$l7" "$info_7"
printf "  %b  %b\n" "$l8" "$info_8"
printf "\n"
