
# minifetch

`minifetch` is a lightweight, terminal‑based system information tool inspired by [neofetch](https://github.com/dylanaraps/neofetch).

It displays your OS, kernel, uptime, CPU, RAM, and a colourful ASCII logo – all in a compact format.

Available in both **Bash** and **C** for maximum speed and minimal resource usage! Perfect for **Termux on Android**, Linux desktops, or any system with a terminal.

---

## ✨ Features

- **Blazing fast & lightweight** – available as a single Bash script or compiled C binary.
- **Colourful output** with ANSI escape codes.
- **Distro‑specific ASCII art** – automatically detects Arch, Ubuntu, Debian, Fedora, Mint, Pop!_OS, and Android/Termux.
- **Press Enter to close** – after displaying info, just hit **Enter** and the terminal window closes (great for launchers or quick glances).
- **Works on Termux** out of the box.

---

## 🛠️ Prerequisites (Installing GCC)

Before compiling the C version, make sure you have a C compiler (`gcc` or `clang`) installed.

### On Linux (Ubuntu / Debian / Mint):
```bash
sudo apt update && sudo apt install build-essential -y
On Arch Linux / EndeavourOS:
Bash
sudo pacman -Sy base-devel gcc --noconfirm
On Fedora:
Bash
sudo dnf install gcc -y
On Termux (Android):
Bash
pkg update && pkg install clang gcc make -y
📦 Installation & Usage
Option 1: The C Version (minifetch.c) – Recommended for speed
Clone the repository

Bash
git clone [https://github.com/anshlabs716/minifetch.git](https://github.com/anshlabs716/minifetch.git)
cd minifetch
Compile the C source

Bash
gcc minifetch.c -o minifetch
Run it

Bash
./minifetch
Option 2: The Bash Script (minifetch.sh)
Clone the repository (if you haven't already)

Bash
git clone [https://github.com/anshlabs716/minifetch.git](https://github.com/anshlabs716/minifetch.git)
cd minifetch
Make it executable

Bash
chmod +x minifetch.sh
Run it

Bash
./minifetch.sh
🚀 Optional: Install System‑Wide
On Linux (with sudo):
Bash
gcc minifetch.c -o minifetch
sudo mv minifetch /usr/local/bin/minifetch
Now you can run it from anywhere by simply typing minifetch.

On Termux (no root):
Bash
gcc minifetch.c -o $PREFIX/bin/minifetch
After that, simply type minifetch in any Termux session.

🖥️ Usage
Just run the command:

Bash
minifetch
It will:

Show system information.

Wait for you to press Enter.

Close the terminal window (if run from a terminal emulator that supports this – most do).

Example Output
Plaintext
       /\       user@host
      /  \      -------------------
     /\   \     OS:     Ubuntu 22.04
    /      \    Kernel: 5.15.0-91-generic (x86_64)
   /   ,,   \   Uptime: up 2 hours
  /   |  |  -\  CPU:    Intel Core i7-8700K
 /_-''    ''-_\ RAM:    2048 MiB / 16000 MiB
                  ██  ██  ██  ██  ██  ██  ██
🛠️ Customization
You can tweak the code directly:

Change colours – edit the C_* color macros/variables at the top.

Add more distros – extend the logic in the ASCII art sections.

Remove the "Press Enter" prompt – clean up the exit/read lines at the end if you prefer an instant exit.

📄 License
This project is licensed under the GPL‑3.0 – see the LICENSE file for details.

🤝 Contributing
Pull requests and issues are welcome! If you have a new distro logo or a bug fix, feel free to open a PR.

⭐ Support
If you like minifetch, give the repository a star on GitHub!

Made with ❤️ by anshlabs716.

