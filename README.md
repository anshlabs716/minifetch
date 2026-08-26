# 🖥️ minifetch

<div align="center">

### ⚡ A Tiny System Information Tool

**Like neofetch, but smaller, simpler, and built with Termux in mind.**

[![C](https://img.shields.io/badge/C-62.4%25-A8B9CC?style=for-the-badge&logo=c&logoColor=white)](https://en.wikipedia.org/wiki/C_(programming_language))
[![Shell](https://img.shields.io/badge/Shell-37.6%25-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Android%20%7C%20Termux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://termux.dev/)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0.html)

</div>

---

## 📖 About

**minifetch** is a lightweight, terminal-based system information tool inspired by [**neofetch**](https://github.com/dylanaraps/neofetch) and [**fastfetch**](https://github.com/fastfetch-cli/fastfetch).

It displays essential system information alongside colorful ASCII artwork while keeping the implementation small and simple.

The project is available in both **C** and **Bash**, making it useful across Linux desktops, Android/Termux, and other Unix-like environments.

> 🪶 **The idea:** take the useful parts of a system fetch tool and keep them compact.

---

## ✨ Features

- ⚡ Lightweight system information display
- 💙 C implementation
- 🐚 Bash implementation
- 🎨 ANSI-colored terminal output
- 🐧 Automatic distribution detection
- 🤖 Android / Termux detection
- 🖼️ Distribution-specific ASCII artwork
- 💻 OS information
- 🧠 Kernel information
- ⏱️ System uptime
- 🔧 CPU information
- 🧮 RAM usage
- 📱 Termux-friendly
- 🪶 Minimal dependencies

---

## 🖥️ Supported Environments

| Environment | Support |
|---|---|
| 🐧 Linux | ✅ Supported |
| 📱 Android / Termux | ✅ Supported |
| 🖥️ Linux desktops | ✅ Supported |
| 🍎 macOS | ⚠️ Not specifically tested |
| 😈 BSD | ⚠️ Not specifically tested |
| 🪟 Windows | ❌ Not currently supported |

---

## 🎨 Distro Detection

`minifetch` can detect and display artwork for several distributions and environments, including:

- 🏹 Arch Linux
- 🟠 Ubuntu
- 🌀 Debian
- 🔵 Fedora
- 🟢 Linux Mint
- 🟣 Pop!_OS
- 🤖 Android / Termux

More distributions can be added by extending the detection and ASCII-art logic.

---

## 🧰 Implementations

### 💙 C

`minifetch.c` is the compiled implementation and is recommended when you want a small native executable.

### 🐚 Bash

`minifetch.sh` provides the same general concept as a shell script without requiring compilation.

---

## 📦 Requirements

### C Version

You need a C compiler such as:

- `gcc`
- `clang`

### Bash Version

You need:

- Bash
- Standard Unix/Linux utilities used by the script

### Termux

For the C version, Termux build tools are required.

---

## 🚀 Installation

### Clone the Repository

~~~~bash
git clone https://github.com/anshlabs716/minifetch.git
cd minifetch
~~~~

### C Version

Compile:

~~~~bash
gcc minifetch.c -o minifetch
~~~~

Run:

~~~~bash
./minifetch
~~~~

### Bash Version

Make the script executable:

~~~~bash
chmod +x minifetch.sh
~~~~

Run:

~~~~bash
./minifetch.sh
~~~~

---

## 📱 Termux

`minifetch` is designed to work well with **Termux on Android**.

Install the required build tools:

~~~~bash
pkg update
pkg install clang gcc make
~~~~

Compile the C version:

~~~~bash
gcc minifetch.c -o minifetch
~~~~

Run:

~~~~bash
./minifetch
~~~~

---

## 🌍 Optional System-Wide Installation

### Linux

Compile:

~~~~bash
gcc minifetch.c -o minifetch
~~~~

Install:

~~~~bash
sudo mv minifetch /usr/local/bin/minifetch
~~~~

Then run:

~~~~bash
minifetch
~~~~

### Termux

Compile directly into the Termux executable directory:

~~~~bash
gcc minifetch.c -o $PREFIX/bin/minifetch
~~~~

Then simply run:

~~~~bash
minifetch
~~~~

---

## 🖥️ Usage

Run:

~~~~bash
minifetch
~~~~

### Example Output

~~~~text
       /\       user@host
      /  \      -------------------
     /\   \     OS:     Arch Linux x86_64
    /      \    Kernel: 7.1.9-arch1-1
   /   ,,   \   Uptime: 11 hours, 42 mins
  /   |  |  -\  CPU:    Intel N150 (4) @ 3.600GHz
 /_-''    ''-_\ RAM:    3463MiB / 7423MiB
                  ██  ██  ██  ██  ██  ██  ██
~~~~

> 💻 **Real hardware specs BTW.**

---

## ⌨️ Terminal Behavior

The current implementation waits for **Enter** after displaying the system information.

This can be useful for quick-glance launcher setups where the terminal window should close afterward.

Behavior may vary depending on the terminal emulator being used.

---

## 🎨 Customization

`minifetch` is intentionally easy to modify.

### 🌈 Colors

Edit the color definitions or macros in the source code.

### 🖼️ ASCII Art

Add or modify distribution-specific ASCII artwork.

### 🐧 Distribution Detection

Extend the detection logic to support additional distributions and environments.

### ⚡ Exit Behavior

The Enter-to-close behavior can be changed if you prefer the program to exit immediately.

---

## 📁 Project Structure

~~~~text
minifetch/
├── LICENSE
├── README.md
├── SECURITY.md
├── minifetch.c
└── minifetch.sh
~~~~

---

## 🛠️ Technical Stack

- 💙 C
- 🐚 Bash
- 🎨 ANSI escape sequences
- 🐧 Linux system information
- 📱 Android / Termux support

---

## 🚧 Development Status

**minifetch is an active personal project and may continue to evolve.**

Planned improvements include:

- [ ] More distribution logos
- [ ] More system information
- [ ] Better platform detection
- [ ] Additional terminal customization
- [ ] More accurate hardware detection
- [ ] Improved portability
- [ ] Performance testing
- [ ] More Termux-specific features

---

## 🤝 Contributing

Pull requests, bug reports, ideas, and improvements are welcome.

Especially useful:

- 🐧 Linux testing
- 📱 Termux testing
- 🎨 New distro artwork
- 💻 C improvements
- 🐚 Shell improvements
- 🛠️ Portability fixes
- 📚 Documentation

---

## 🔒 Security

If you discover a security issue or unexpected behavior, please report it responsibly through the repository's security policy.

See [`SECURITY.md`](SECURITY.md).

---

## 📜 License

This project is licensed under the **GNU General Public License v3.0**.

See [`LICENSE`](LICENSE) for the full license text.

---

## 👤 Author

Made by **AnshLabs716** 🔥

---

<div align="center">

### ⚡ minifetch

**Like neofetch. Just mini.**

**C • Bash • Linux • Termux**

</div>
