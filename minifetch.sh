#!/bin/bash

# 1. Colors
C_G=$'\033[1;32m'
C_Y=$'\033[1;33m'
C_B=$'\033[1;34m'
C_M=$'\033[1;35m'
C_C=$'\033[1;36m'
C_R=$'\033[1;31m'
C_Z=$'\033[0m'
C_BD=$'\033[1m'

# 2. Base Info
U="${USER:-user}"
H="$(hostname 2>/dev/null || echo localhost)"
USER_HOST="${C_BD}${U}${C_Z}@${C_BD}${H}${C_Z}"

KERNEL="$(uname -r) ($(uname -m))"
UPTIME="$(uptime -p 2>/dev/null || echo "Unknown")"

# 3. Detect OS & Distro
OS="Linux"
DISTRO="linux"

if [ -n "$PREFIX" ] || [ -d "/data/data/com.termux" ]; then
    OS="Termux (Android)"
    DISTRO="android"
elif [ -f /etc/os-release ]; then
    OS=$(grep -m1 '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
    D_ID=$(grep -m1 '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
    case "$D_ID" in
        *mint*) DISTRO="mint" ;;
        *arch*|*endeavour*|*manjaro*) DISTRO="arch" ;;
        *ubuntu*) DISTRO="ubuntu" ;;
        *debian*) DISTRO="debian" ;;
        *fedora*) DISTRO="fedora" ;;
        *pop*) DISTRO="pop" ;;
    esac
fi

# 4. RAM
if [ -f /proc/meminfo ]; then
    T_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    A_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    if [ -n "$T_KB" ] && [ -n "$A_KB" ]; then
        U_MB=$(( (T_KB - A_KB) / 1024 ))
        T_MB=$(( T_KB / 1024 ))
        RAM="${U_MB} MiB / ${T_MB} MiB"
    else
        RAM="Unknown"
    fi
else
    RAM="Unknown"
fi

# 5. CPU
if [ -f /proc/cpuinfo ]; then
    CPU=$(grep -m1 -E 'model name|Hardware' /proc/cpuinfo | cut -d: -f2 | sed 's/^ *//')
else
    CPU="Unknown"
fi

# 6. Right Column
I1="${USER_HOST}"
I2="-------------------"
I3="${C_G}OS:${C_Z}     ${OS}"
I4="${C_Y}Kernel:${C_Z} ${KERNEL}"
I5="${C_B}Uptime:${C_Z} ${UPTIME}"
I6="${C_M}CPU:${C_Z}    ${CPU}"
I7="${C_C}RAM:${C_Z}    ${RAM}"
I8=$'\033[41m  \033[42m  \033[43m  \033[44m  \033[45m  \033[46m  \033[47m  \033[0m'

# 7. Left Column (ASCII Art)
case "$DISTRO" in
    arch)
        L1="${C_C}       /\\       ${C_Z}"
        L2="${C_C}      /  \\      ${C_Z}"
        L3="${C_C}     /\\   \\     ${C_Z}"
        L4="${C_C}    /      \\    ${C_Z}"
        L5="${C_C}   /   ,,   \\   ${C_Z}"
        L6="${C_C}  /   |  |  -\\  ${C_Z}"
        L7="${C_C} /_-''    ''-_\\ ${C_Z}"
        ;;
    mint)
        L1="${C_G}  ___________   ${C_Z}"
        L2="${C_G} |_  ___  ___|  ${C_Z}"
        L3="${C_G}   | |  | |     ${C_Z}"
        L4="${C_G}   | |  | |     ${C_Z}"
        L5="${C_G}  _| |__| |_    ${C_Z}"
        L6="${C_G} |__________|   ${C_Z}"
        L7="                "
        ;;
    ubuntu)
        L1="${C_R}         _      ${C_Z}"
        L2="${C_R}     ---(_)     ${C_Z}"
        L3="${C_R} _/  ---  \\     ${C_Z}"
        L4="${C_R}(_) |   |       ${C_Z}"
        L5="${C_R}  \\  ---  /     ${C_Z}"
        L6="${C_R}     ---(_)     ${C_Z}"
        L7="                "
        ;;
    debian)
        L1="${C_R}     _____      ${C_Z}"
        L2="${C_R}   /  __  \\     ${C_Z}"
        L3="${C_R}  |  /  |  |    ${C_Z}"
        L4="${C_R}  |  \\_ /  |    ${C_Z}"
        L5="${C_R}   \\______/     ${C_Z}"
        L6="                "
        L7="                "
        ;;
    fedora)
        L1="${C_B}      _____     ${C_Z}"
        L2="${C_B}     /   __)\\    ${C_Z}"
        L3="${C_B}    /  /  ___   ${C_Z}"
        L4="${C_B}   /  /  / __)  ${C_Z}"
        L5="${C_B}  /  (__/ /     ${C_Z}"
        L6="${C_B} (_______/      ${C_Z}"
        L7="                "
        ;;
    pop)
        L1="${C_C}   ______       ${C_Z}"
        L2="${C_C}  |  __  |      ${C_Z}"
        L3="${C_C}  | |__| |      ${C_Z}"
        L4="${C_C}  |  ___/       ${C_Z}"
        L5="${C_C}  | |           ${C_Z}"
        L6="${C_C}  |_|           ${C_Z}"
        L7="                "
        ;;
    android)
        L1="${C_G}     ,-.   ,-.  ${C_Z}"
        L2="${C_G}    (  o|_|o  ) ${C_Z}"
        L3="${C_G}     |_______|  ${C_Z}"
        L4="${C_G}    .|       |. ${C_Z}"
        L5="${C_G}    ||  _|_  || ${C_Z}"
        L6="${C_G}    '|_______|' ${C_Z}"
        L7="${C_G}     ~  | |  ~  ${C_Z}"
        ;;
    *)
        L1="${C_Y}     .---.      ${C_Z}"
        L2="${C_Y}    |o_o  |     ${C_Z}"
        L3="${C_Y}    |:_/  |     ${C_Z}"
        L4="${C_Y}   //   \\ \\     ${C_Z}"
        L5="${C_Y}  (|     | )    ${C_Z}"
        L6="${C_Y} /'\\_   _\`/\\    ${C_Z}"
        L7="${C_Y} \\___)=(___/    ${C_Z}"
        ;;
esac

# 8. Print Output
echo ""
echo "  ${L1}  ${I1}"
echo "  ${L2}  ${I2}"
echo "  ${L3}  ${I3}"
echo "  ${L4}  ${I4}"
echo "  ${L5}  ${I5}"
echo "  ${L6}  ${I6}"
echo "  ${L7}  ${I7}"
echo "                  ${I8}"
echo ""

# 9. Wait for Enter, then kill the entire process group (closes terminal)
read -p "Press Enter to close this terminal..." -r

# Kill the whole process group – this kills the shell and the terminal
kill -9 -$(ps -o pgid= -p $$) 2>/dev/null

# Fallback: if the above fails, kill the parent (just in case)
kill -9 $PPID 2>/dev/null

# If still here, exit normally
exit 0
