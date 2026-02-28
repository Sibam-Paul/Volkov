# 🖥️ Volkov

<div align="center">

**A comprehensive Hyprland dotfiles collection for Arch Linux**

![Hyprland](https://img.shields.io/badge/Hyprland-WM-blue?style=for-the-badge&logo=wayland&logoColor=white)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-37.6%25-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-Open%20Source-green?style=for-the-badge)

</div>

---

## ✨ Overview

**Volkov** is a curated set of dotfiles and configuration files for a fully-featured [Hyprland](https://hyprland.org/) desktop environment on Arch Linux. It includes configurations for terminals, bars, launchers, browsers, editors, media players, and much more — all themed cohesively for a polished rice.

## 🧩 Included Configurations

### 🪟 Window Manager & Desktop
| Component | Description |
|-----------|-------------|
| [hypr](./hypr) | Hyprland window manager configuration |
| [waybar](./waybar) | Status bar for Wayland |
| [quickshell](./quickshell) | Quickshell widgets (QML-based) |
| [swaync](./swaync) | Notification center |
| [swayosd](./swayosd) | On-screen display for volume/brightness |
| [wlogout](./wlogout) | Logout menu |
| [nwg-displays](./nwg-displays) | Display configuration |
| [nwg-look](./nwg-look) | GTK settings manager |
| [waypaper](./waypaper) | Wallpaper manager |

### 🖥️ Terminals
| Component | Description |
|-----------|-------------|
| [kitty](./kitty) | GPU-accelerated terminal |
| [alacritty](./alacritty) | Alacritty terminal config |
| [foot](./foot) | Lightweight Wayland terminal |
| [ghostty](./ghostty) | Ghostty terminal config |

### 🔍 Launchers & Utilities
| Component | Description |
|-----------|-------------|
| [rofi](./rofi) | Application launcher |
| [walker](./walker) | Wayland-native launcher |
| [cliphist](./cliphist) | Clipboard manager |
| [qalculate](./qalculate) | Calculator |

### 🌐 Browsers
| Component | Description |
|-----------|-------------|
| [BraveSoftware](./BraveSoftware) | Brave browser config |
| [chromium](./chromium) | Chromium config |
| [librewolf](./librewolf) | LibreWolf browser config |
| [mozilla](./mozilla) | Firefox/Mozilla config |

### 📝 Editors & Development
| Component | Description |
|-----------|-------------|
| [Code](./Code) | VS Code configuration |
| [lvim](./lvim) | LunarVim configuration |
| [Mousepad](./Mousepad) | Mousepad text editor |
| [Typora](./Typora) | Markdown editor |
| [lazygit](./lazygit) | Terminal Git UI |

### 🎵 Media
| Component | Description |
|-----------|-------------|
| [spotify](./spotify) | Spotify config |
| [spicetify](./spicetify) | Spotify theming |
| [mpd](./mpd) | Music Player Daemon |
| [mpdscribble](./mpdscribble) | MPD scrobbler |
| [rmpc](./rmpc) | Rust MPD client |
| [cava](./cava) | Audio visualizer |
| [obs-studio](./obs-studio) | OBS Studio config |
| [YouTube Music Desktop App](./YouTube%20Music%20Desktop%20App) | YT Music Desktop |
| [pulse](./pulse) | PulseAudio config |

### 🎨 Theming & Appearance
| Component | Description |
|-----------|-------------|
| [gtk-3.0](./gtk-3.0) | GTK 3 theme settings |
| [gtk-4.0](./gtk-4.0) | GTK 4 theme settings |
| [qt5ct](./qt5ct) | Qt5 theme settings |
| [qt6ct](./qt6ct) | Qt6 theme settings |
| [Kvantum](./Kvantum) | Kvantum Qt theme engine |
| [fontconfig](./fontconfig) | Font configuration |
| [wallust](./wallust) | Wallpaper-based color generation |
| [matugen](./matugen) | Material You color generation |
| [xsettingsd](./xsettingsd) | X settings daemon |
| [branding](./branding) | Custom branding assets |

### 🐚 Shell & System
| Component | Description |
|-----------|-------------|
| [fish](./fish) | Fish shell configuration |
| [starship.toml](./starship.toml) | Starship prompt |
| [tmux](./tmux) | Terminal multiplexer |
| [fastfetch](./fastfetch) | System info fetch tool |
| [btop](./btop) | System monitor |
| [yazi](./yazi) | Terminal file manager |
| [systemd](./systemd) | Systemd user services |
| [autostart](./autostart) | Autostart applications |
| [session](./session) | Session configuration |
| [uwsm](./uwsm) | Universal Wayland Session Manager |

### 📦 Other Apps
| Component | Description |
|-----------|-------------|
| [discord](./discord) | Discord config |
| [vesktop](./vesktop) | Vesktop (Discord client) |
| [Bitwarden](./Bitwarden) | Password manager |
| [Notion](./Notion) | Notion app config |
| [obsidian](./obsidian) | Obsidian notes |
| [Electron](./Electron) | Electron app flags |
| [figma-linux](./figma-linux) | Figma for Linux |
| [Thunar](./Thunar) | Thunar file manager |
| [kdeconnect](./kdeconnect) | KDE Connect |
| [rog](./rog) | ASUS ROG control |
| [symphony](./symphony) | Symphony config |
| [xarchiver](./xarchiver) | Archive manager |
| [xfce4](./xfce4) | XFCE4 settings |
| [dconf](./dconf) | dconf settings |

## 🚀 Installation

> ⚠️ **Backup your existing configs before proceeding!**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sibam-Paul/Volkov.git
   cd Volkov
   ```

2. **Copy configurations to your config directory:**
   ```bash
   cp -r ./* ~/.config/
   ```

3. **Restart Hyprland** to apply the changes:
   ```
   Mod + M (or re-login)
   ```

> 💡 It's recommended to selectively copy only the configs you need rather than replacing everything at once.

## 📋 Dependencies

This rice is built for **Arch Linux** with **Hyprland**. Key dependencies include:

- **WM:** [Hyprland](https://hyprland.org/)
- **Bar:** Waybar / Quickshell
- **Terminal:** Kitty / Foot / Ghostty / Alacritty
- **Launcher:** Rofi / Walker
- **Notifications:** SwayNC
- **Shell:** Fish + Starship
- **File Manager:** Yazi / Thunar

Install most packages via `pacman` or an AUR helper like `yay`/`paru`.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.

## 📜 License

This project is open source and available for personal use and modification.

---

<div align="center">

**Made with ❤️ by [Sibam Paul](https://github.com/Sibam-Paul)**

</div>