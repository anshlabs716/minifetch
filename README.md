# minifetch

**minifetch** is a lightweight, terminal‑based system information tool inspired by [neofetch](https://github.com/dylanaraps/neofetch).  
It displays your OS, kernel, uptime, CPU, RAM, and a colourful ASCII logo – all in a compact format.  
Perfect for **Termux on Android**, Linux desktops, or any system with a Bash shell.

---

## ✨ Features

- **Minimal & fast** – single Bash script, no dependencies.  
- **Colourful output** with ANSI escape codes.  
- **Distro‑specific ASCII art** – automatically detects Arch, Ubuntu, Debian, Fedora, Mint, Pop!_OS, and Android/Termux.  
- **Press Enter to close** – after displaying info, just hit **Enter** and the terminal window closes (great for launchers or quick glances).  
- **Works on Termux** out of the box.

---

## 📦 Installation

### 1. Clone the repository

```bash
git clone https://github.com/anshlabs716/minifetch.git
cd minifetch
```

### 2. Make it executable

```bash
chmod +x minifetch.sh
```

### 3. Run it directly

```bash
./minifetch.sh
```

---

## 🚀 Optional: Install system‑wide (like `neofetch`)

**On Linux (with sudo):**

```bash
sudo mv minifetch.sh /usr/local/bin/minifetch
```
Now you can run it from anywhere by typing `minifetch`.

**On Termux (no root):**

```bash
mv minifetch.sh $PREFIX/bin/minifetch
```
After that, simply type `minifetch` in any Termux session.

---

## 🖥️ Usage

Just run the script:

```bash
minifetch
```

It will:
- Show system information.
- Wait for you to press **Enter**.
- **Close the terminal window** (if run from a terminal emulator that supports this – most do).

### Example output

```
       /\       user@host
      /  \      -------------------
     /\   \     OS:     Ubuntu 22.04
    /      \    Kernel: 5.15.0-91-generic (x86_64)
   /   ,,   \   Uptime: up 2 hours
  /   |  |  -\  CPU:    Intel Core i7-8700K
 /_-''    ''-_\ RAM:    2048 MiB / 16000 MiB
                  ██  ██  ██  ██  ██  ██  ██
```

---

## 🛠️ Customization

You can tweak the script directly:

- **Change colours** – edit the `C_*` variables at the top.
- **Add more distros** – extend the `case` statement in the ASCII art section.
- **Remove the "Press Enter" prompt** – delete the `read` and `kill` lines at the end if you prefer instant exit.

---

## 📄 License

This project is licensed under the **GPL‑3.0** – see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Pull requests and issues are welcome! If you have a new distro logo or a bug fix, feel free to open a PR.

---

## ⭐ Support

If you like `minifetch`, give the repository a star on GitHub!

---

Made with ❤️ by [anshlabs716](https://github.com/anshlabs716)
