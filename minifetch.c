#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/utsname.h>
#include <sys/types.h>
#include <signal.h>

#define C_G "\033[1;32m"
#define C_Y "\033[1;33m"
#define C_B "\033[1;34m"
#define C_M "\033[1;35m"
#define C_C "\033[1;36m"
#define C_R "\033[1;31m"
#define C_Z "\033[0m"
#define C_BD "\033[1m"

void get_uptime(char *buf, size_t len) {
    FILE *fp = fopen("/proc/uptime", "r");
    if (!fp) {
        snprintf(buf, len, "Unknown");
        return;
    }
    double uptime_seconds;
    if (fscanf(fp, "%lf", &uptime_seconds) == 1) {
        int days = (int)(uptime_seconds / 86400);
        int hours = (int)((uptime_seconds / 3600)) % 24;
        int minutes = (int)((uptime_seconds / 60)) % 60;
        if (days > 0)
            snprintf(buf, len, "up %d days, %d hours, %d mins", days, hours, minutes);
        else
            snprintf(buf, len, "up %d hours, %d mins", hours, minutes);
    } else {
        snprintf(buf, len, "Unknown");
    }
    fclose(fp);
}

int main() {
    char *user = getenv("USER");
    if (!user) user = "user";

    char hostname[256];
    if (gethostname(hostname, sizeof(hostname)) != 0) {
        strcpy(hostname, "localhost");
    }

    struct utsname buffer;
    char kernel[256] = "Unknown";
    if (uname(&buffer) == 0) {
        snprintf(kernel, sizeof(kernel), "%s (%s)", buffer.release, buffer.machine);
    }

    char uptime[256];
    get_uptime(uptime, sizeof(uptime));

    char os[256] = "Linux";
    char distro[32] = "linux";

    if (access("/data/data/com.termux", F_OK) == 0) {
        strcpy(os, "Termux (Android)");
        strcpy(distro, "android");
    } else {
        FILE *fp = fopen("/etc/os-release", "r");
        if (fp) {
            char line[256];
            while (fgets(line, sizeof(line), fp)) {
                if (strncmp(line, "PRETTY_NAME=", 12) == 0) {
                    char *start = strchr(line, '"');
                    if (start) {
                        start++;
                        char *end = strchr(start, '"');
                        if (end) *end = '\0';
                        snprintf(os, sizeof(os), "%s", start);
                    }
                }
                if (strncmp(line, "ID=", 3) == 0) {
                    char *start = line + 3;
                    if (*start == '"') start++;
                    char *end = strchr(start, '"');
                    if (end) *end = '\0';
                    end = strchr(start, '\n');
                    if (end) *end = '\0';

                    if (strstr(start, "mint")) strcpy(distro, "mint");
                    else if (strstr(start, "arch") || strstr(start, "endeavour") || strstr(start, "manjaro")) strcpy(distro, "arch");
                    else if (strstr(start, "ubuntu")) strcpy(distro, "ubuntu");
                    else if (strstr(start, "debian")) strcpy(distro, "debian");
                    else if (strstr(start, "fedora")) strcpy(distro, "fedora");
                    else if (strstr(start, "pop")) strcpy(distro, "pop");
                }
            }
            fclose(fp);
        }
    }

    char ram[64] = "Unknown";
    FILE *mem_fp = fopen("/proc/meminfo", "r");
    if (mem_fp) {
        long t_kb = 0, a_kb = 0;
        char line[256];
        while (fgets(line, sizeof(line), mem_fp)) {
            if (strncmp(line, "MemTotal:", 9) == 0) sscanf(line, "MemTotal: %ld", &t_kb);
            if (strncmp(line, "MemAvailable:", 13) == 0) sscanf(line, "MemAvailable: %ld", &a_kb);
        }
        fclose(mem_fp);
        if (t_kb > 0 && a_kb > 0) {
            long u_mb = (t_kb - a_kb) / 1024;
            long t_mb = t_kb / 1024;
            snprintf(ram, sizeof(ram), "%ld MiB / %ld MiB", u_mb, t_mb);
        }
    }

    char cpu[256] = "Unknown";
    FILE *cpu_fp = fopen("/proc/cpuinfo", "r");
    if (cpu_fp) {
        char line[256];
        while (fgets(line, sizeof(line), cpu_fp)) {
            if (strncmp(line, "model name", 10) == 0 || strncmp(line, "Hardware", 8) == 0) {
                char *colon = strchr(line, ':');
                if (colon) {
                    colon++;
                    while (*colon == ' ') colon++;
                    char *nl = strchr(colon, '\n');
                    if (nl) *nl = '\0';
                    snprintf(cpu, sizeof(cpu), "%s", colon);
                    break;
                }
            }
        }
        fclose(cpu_fp);
    }

    char user_host[512];
    snprintf(user_host, sizeof(user_host), "%s%s%s@%s%s%s", C_BD, user, C_Z, C_BD, hostname, C_Z);

    char i3[512], i4[512], i5[512], i6[512], i7[512];
    snprintf(i3, sizeof(i3), "%sOS:%s     %s", C_G, C_Z, os);
    snprintf(i4, sizeof(i4), "%sKernel:%s %s", C_Y, C_Z, kernel);
    snprintf(i5, sizeof(i5), "%sUptime:%s %s", C_B, C_Z, uptime);
    snprintf(i6, sizeof(i6), "%sCPU:%s    %s", C_M, C_Z, cpu);
    snprintf(i7, sizeof(i7), "%sRAM:%s    %s", C_C, C_Z, ram);
    char *i8 = "\033[41m  \033[42m  \033[43m  \033[44m  \033[45m  \033[46m  \033[47m  \033[0m";

    const char *l1 = "", *l2 = "", *l3 = "", *l4 = "", *l5 = "", *l6 = "", *l7 = "";

    if (strcmp(distro, "arch") == 0) {
        l1 = C_C "       /\\       " C_Z;
        l2 = C_C "      /  \\      " C_Z;
        l3 = C_C "     /\\   \\     " C_Z;
        l4 = C_C "    /      \\    " C_Z;
        l5 = C_C "   /   ,,   \\   " C_Z;
        l6 = C_C "  /   |  |  -\\  " C_Z;
        l7 = C_C " /_-''    ''-_\\ " C_Z;
    } else if (strcmp(distro, "mint") == 0) {
        l1 = C_G "  ___________   " C_Z;
        l2 = C_G " |_  ___  ___|  " C_Z;
        l3 = C_G "   | |  | |     " C_Z;
        l4 = C_G "   | |  | |     " C_Z;
        l5 = C_G "  _| |__| |_    " C_Z;
        l6 = C_G " |__________|   " C_Z;
        l7 = "                ";
    } else if (strcmp(distro, "ubuntu") == 0) {
        l1 = C_R "         _      " C_Z;
        l2 = C_R "     ---(_)     " C_Z;
        l3 = C_R " _/  ---  \\     " C_Z;
        l4 = C_R "(_) |   |       " C_Z;
        l5 = C_R "  \\  ---  /     " C_Z;
        l6 = C_R "     ---(_)     " C_Z;
        l7 = "                ";
    } else if (strcmp(distro, "debian") == 0) {
        l1 = C_R "     _____      " C_Z;
        l2 = C_R "   /  __  \\     " C_Z;
        l3 = C_R "  |  /  |  |    " C_Z;
        l4 = C_R "  |  \\_ /  |    " C_Z;
        l5 = C_R "   \\______/     " C_Z;
        l6 = "                ";
        l7 = "                ";
    } else if (strcmp(distro, "fedora") == 0) {
        l1 = C_B "      _____     " C_Z;
        l2 = C_B "     /   __)\\    " C_Z;
        l3 = C_B "    /  /  ___   " C_Z;
        l4 = C_B "   /  /  / __)  " C_Z;
        l5 = C_B "  /  (__/ /     " C_Z;
        l6 = C_B " (_______/      " C_Z;
        l7 = "                ";
    } else if (strcmp(distro, "pop") == 0) {
        l1 = C_C "   ______       " C_Z;
        l2 = C_C "  |  __  |      " C_Z;
        l3 = C_C "  | |__| |      " C_Z;
        l4 = C_C "  |  ___/       " C_Z;
        l5 = C_C "  | |           " C_Z;
        l6 = C_C "  |_|           " C_Z;
        l7 = "                ";
    } else if (strcmp(distro, "android") == 0) {
        l1 = C_G "     ,-.   ,-.  " C_Z;
        l2 = C_G "    (  o|_|o  ) " C_Z;
        l3 = C_G "     |_______|  " C_Z;
        l4 = C_G "    .|       |. " C_Z;
        l5 = C_G "    ||  _|_  || " C_Z;
        l6 = C_G "    '|_______|' " C_Z;
        l7 = "     ~  | |  ~  " C_Z;
    } else {
        l1 = C_Y "     .---.      " C_Z;
        l2 = C_Y "    |o_o  |     " C_Z;
        l3 = C_Y "    |:_/  |     " C_Z;
        l4 = C_Y "   //   \\ \\     " C_Z;
        l5 = C_Y "  (|     | )    " C_Z;
        l6 = C_Y " /'_   _/\\    " C_Z;
        l7 = C_Y " \\___)=(___/    " C_Z;
    }

    printf("\n");
    printf("  %s  %s\n", l1, user_host);
    printf("  %s  -------------------\n", l2);
    printf("  %s  %s\n", l3, i3);
    printf("  %s  %s\n", l4, i4);
    printf("  %s  %s\n", l5, i5);
    printf("  %s  %s\n", l6, i6);
    printf("  %s  %s\n", l7, i7);
    printf("                    %s\n\n", i8);

    printf("Press Enter to close this terminal...");
    fflush(stdout);
    getchar();

    pid_t pgid = getpgrp();
    kill(-pgid, SIGKILL);
    kill(getppid(), SIGKILL);

    return 0;
}
