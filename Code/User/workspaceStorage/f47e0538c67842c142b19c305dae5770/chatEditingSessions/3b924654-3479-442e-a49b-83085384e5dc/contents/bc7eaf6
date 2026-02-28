# Symphony Screensaver - Complete Implementation Guide

## 📋 Overview

The **Symphony Screensaver** is a terminal-based animated screensaver that displays beautiful ASCII art with dynamic visual effects. It's part of your dotfiles ecosystem and integrates seamlessly with Hyprland and Hypridle.

### What Makes It Special
- 🎨 **Terminal-based** - Uses TTE (Terminal Text Effects) for animations
- 🎭 **Random effects** - Matrix, Fireworks, Rain, Decrypt, and many more
- 🖥️ **Multi-monitor support** - Launches on all monitors simultaneously
- ⌨️ **Smart exit** - Exits immediately on any keyboard/mouse input
- 🚀 **Lightweight** - No heavy graphics, just pure terminal magic

---

## 🗂️ FILE STRUCTURE & FLOW

### Directory Layout
```
dotfiles/
├── branding/
│   ├── symphony.txt          ← ASCII art (the showpiece)
│   ├── logo.txt
│   ├── musical.txt
│   ├── vyrx.txt
│   └── dp.txt
├── install/
│   └── themes/
│       ├── symphony          ← Theme switcher script
│       ├── symphony-tui      ← TUI version
│       ├── symphony-import/  ← Theme color importer
│       │   ├── import.sh
│       │   ├── init.sh
│       │   ├── terminals.sh
│       │   ├── hyprland.sh
│       │   ├── gtk.sh
│       │   └── ...
│       └── hooks/
│           ├── 00-alacritty.sh
│           ├── 00-ghostty.sh
│           ├── 10-gtk.sh
│           └── ...
├── .config/
│   └── hypr/
│       ├── hypridle.conf     ← Inactivity trigger
│       └── scripts/
│           └── screensaver   ← Main screensaver script
└── themes/
    ├── dynamic/
    ├── espresso/
    ├── rose-pine/
    ├── tokyo-night/
    └── ...

Home Directory:
├── screensaver-launcher.sh   ← Multi-monitor launcher
├── screensaver-standalone.sh ← All-in-one implementation
├── SCREENSAVER_README.md     ← Quick start guide
├── omarchy_screensaver_analysis.md
└── screensaver_flow_diagram.txt
```

---

## 🔄 EXECUTION FLOW

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: INACTIVITY DETECTION                                │
│ User idle for 150 seconds (2.5 minutes)                     │
│ hypridle.conf monitors and triggers                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 2: LAUNCHER SCRIPT                                     │
│ screensaver-launcher.sh                                     │
│                                                              │
│ • Checks if TTE is installed                               │
│ • Verifies screensaver not already running                 │
│ • Detects terminal (Alacritty/Ghostty/Kitty)              │
│ • Gets list of monitors                                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 3: TERMINAL LAUNCH (per monitor)                       │
│ For each monitor:                                            │
│ • Focus monitor with hyprctl                               │
│ • Launch terminal with screensaver class                   │
│ • Execute screensaver command                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 4: WINDOW RULES (Hyprland)                             │
│ Auto-applied window rules:                                  │
│ • windowrule = fullscreen on, class:^(my.screensaver)$     │
│ • windowrule = float on, class:^(my.screensaver)$          │
│                                                              │
│ → Terminal goes fullscreen automatically                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 5: SCREENSAVER EXECUTION                               │
│ .config/hypr/scripts/screensaver                            │
│                                                              │
│ • Hide cursor (hyprctl keyword cursor:invisible true)      │
│ • Set background to black                                  │
│ • Enable mouse/keyboard input tracking                     │
│ • Run TTE with ASCII art                                   │
│ • Monitor for any user input                               │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 6: TTE (Terminal Text Effects)                         │
│ Command: tte -i branding/symphony.txt ...                  │
│                                                              │
│ • Reads ASCII art from file                                │
│ • Applies random visual effect (Matrix, Fireworks, etc.)   │
│ • Renders at 120 FPS                                       │
│ • Reuses canvas (no flickering)                            │
│ • Animates continuously                                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 7: INPUT DETECTION & EXIT                              │
│ Continuous monitoring:                                       │
│ • Check for keyboard input (read -n1 -t 1)                │
│ • Check for mouse input (via trackpad/mouse)              │
│ • Check if window lost focus                              │
│                                                              │
│ On any input:                                               │
│ • Kill TTE process (pkill -x tte)                         │
│ • Show cursor (hyprctl keyword cursor:invisible false)    │
│ • Exit screensaver windows                                │
│ • Return to normal desktop                                │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 KEY COMPONENTS EXPLAINED

### 1. **hypridle.conf** - Inactivity Trigger
```bash
# Location: ~/.config/hypr/hypridle.conf

listener {
    timeout = 150                    # 2.5 minutes of inactivity
    on-timeout = pidof hyprlock || ~/.local/bin/screensaver-launch
}
```

**What it does:**
- Monitors user activity (keyboard, mouse)
- Counts inactivity duration
- Triggers screensaver launch after 150 seconds
- Skips if screen is already locked

---

### 2. **screensaver-launcher.sh** - Terminal Orchestrator
```bash
#!/bin/bash
SCREENSAVER_CMD="$HOME/.local/bin/screensaver-cmd"
WINDOW_CLASS="my.screensaver"

# Check dependencies
if ! command -v tte &>/dev/null; then
  notify-send "Screensaver Error" "TTE not installed"
  exit 1
fi

# Prevent duplicates
if pgrep -f "$WINDOW_CLASS" >/dev/null; then
  exit 0
fi

# For each monitor:
for monitor in $(hyprctl monitors -j | jq -r '.[] | .name'); do
  hyprctl dispatch focusmonitor "$monitor"
  
  # Launch terminal with screensaver
  alacritty --class="$WINDOW_CLASS" \
    -o colors.primary.background="0x000000" \
    -e "$SCREENSAVER_CMD"
done
```

**Key functions:**
- ✅ Dependency checking (tte, hyprctl, jq)
- ✅ Duplicate prevention (prevents multiple instances)
- ✅ Terminal detection (Alacritty/Ghostty/Kitty)
- ✅ Multi-monitor support (launches on all screens)
- ✅ Terminal-specific configuration

---

### 3. **.config/hypr/scripts/screensaver** - Main Logic
```bash
#!/bin/bash

# Helper: Check if screensaver is focused
screensaver_in_focus() {
  hyprctl activewindow -j | jq -e '.class == "Screensaver"' >/dev/null 2>&1
}

# Helper: Clean exit
exit_screensaver() {
  hyprctl keyword cursor:invisible false
  pkill -x tte 2>/dev/null
  pkill -f Screensaver 2>/dev/null
  exit 0
}

# Trap signals (Ctrl+C, SIGTERM, etc.)
trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

# Enable mouse/keyboard input tracking
printf '\e[?1000h\e[?1003h'
while read -rsn1 -t 0.1; do :; done  # Flush pending input

# Set background to black
printf '\033]11;rgb:00/00/00\007'

# Hide cursor
hyprctl keyword cursor:invisible true &>/dev/null

# Get TTY for process monitoring
tty=$(tty 2>/dev/null)

# Main loop: Run TTE continuously
while true; do
  tte -i ~/dotfiles/branding/symphony.txt \
    --frame-rate 120 \
    --canvas-width 0 \
    --canvas-height 0 \
    --reuse-canvas \
    --anchor-canvas c \
    --anchor-text c \
    --random-effect \
    --exclude-effects dev_worm \
    --no-eol \
    --no-restore-cursor &

  # Monitor for input
  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    if read -rsn1 -t 1 || ! screensaver_in_focus; then
      exit_screensaver
    fi
  done
done
```

**Flow breakdown:**
1. **Trap signals** - Catch Ctrl+C and system signals
2. **Enable tracking** - Mouse and keyboard input detection
3. **Hide cursor** - Makes it invisible during screensaver
4. **Main loop** - Runs TTE until user input detected
5. **Input detection** - Monitors both keyboard AND window focus
6. **Clean exit** - Kills TTE, shows cursor, exits windows

---

### 4. **symphony.txt** - The ASCII Art
```
        ♪                                            ♫
   ▄▄▄▄▄                                         ♪
  ██▀▀▀▀█▄                      █▄           ♬
  ▀██▄  ▄▀       ▄              ██          ▄
    ▀██▄▄  ██ ██ ███▄███▄ ████▄ ████▄ ▄███▄ ████▄ ██ ██
  ▄   ▀██▄ ██▄██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██▄██
  ▀██████▀▄▄▀██▀▄██ ██ ▀█▄████▀▄██ ██▄▀███▀▄██ ▀█▄▄▀██▀
     ♫       ██           ██                        ██
           ▀▀▀     ♪      ▀              ♬        ▀▀▀
```

**Characteristics:**
- Shows "SYMPHONY" text with music notes
- Uses block/box-drawing characters
- Center-aligned and padded
- Perfect for terminal display

---

### 5. **Hyprland Window Rules**
```bash
# Location: ~/.config/hypr/hyprland.conf

windowrule = fullscreen on, class:^(my.screensaver)$
windowrule = float on, class:^(my.screensaver)$
```

**What they do:**
- Automatically make screensaver windows fullscreen
- Float the window (not tiled)
- Apply on window creation automatically

---

## 🚀 HOW TO REPLICATE IT

### Step 1: Install Dependencies
```bash
# Arch Linux
sudo pacman -S python-terminaltexteffects hyprland hypridle alacritty jq

# Fedora
sudo dnf install terminaltexteffects hyprland jq alacritty

# Ubuntu/Debian
pip install terminaltexteffects
sudo apt install hyprland jq alacritty
```

### Step 2: Create ASCII Art
```bash
# Option A: Use figlet (automatic)
mkdir -p ~/.config/screensaver
echo "YOUR TEXT" | figlet -f banner > ~/.config/screensaver/art.txt

# Option B: Use symphony.txt from your dotfiles
mkdir -p ~/.config/screensaver
cp ~/dotfiles/branding/symphony.txt ~/.config/screensaver/art.txt

# Option C: Create manually
cat > ~/.config/screensaver/art.txt << 'EOF'
    YOUR ASCII ART HERE
    Can be multi-line
    Created with any ASCII art tool
EOF
```

### Step 3: Create Screensaver Script
```bash
mkdir -p ~/.local/bin

cat > ~/.local/bin/screensaver-cmd << 'EOF'
#!/bin/bash

screensaver_in_focus() {
  hyprctl activewindow -j 2>/dev/null | \
    jq -e '.class == "my.screensaver"' >/dev/null 2>&1
}

exit_screensaver() {
  hyprctl keyword cursor:invisible false
  pkill -x tte 2>/dev/null
  pkill -f my.screensaver 2>/dev/null
  exit 0
}

trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT
printf '\e[?1000h\e[?1003h'
while read -rsn1 -t 0.1; do :; done
printf '\033]11;rgb:00/00/00\007'
hyprctl keyword cursor:invisible true &>/dev/null

tty=$(tty 2>/dev/null)

while true; do
  tte -i ~/.config/screensaver/art.txt \
    --frame-rate 120 \
    --canvas-width 0 \
    --canvas-height 0 \
    --reuse-canvas \
    --anchor-canvas c \
    --anchor-text c \
    --random-effect \
    --exclude-effects dev_worm \
    --no-eol \
    --no-restore-cursor &

  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    if read -rsn1 -t 1 || ! screensaver_in_focus; then
      exit_screensaver
    fi
  done
done
EOF

chmod +x ~/.local/bin/screensaver-cmd
```

### Step 4: Create Launcher Script
```bash
cat > ~/.local/bin/screensaver-launch << 'EOF'
#!/bin/bash

SCREENSAVER_CMD="$HOME/.local/bin/screensaver-cmd"
WINDOW_CLASS="my.screensaver"

# Check if TTE is installed
if ! command -v tte &>/dev/null; then
  echo "TTE not installed"
  exit 1
fi

# Prevent duplicates
if pgrep -f "$WINDOW_CLASS" >/dev/null; then
  exit 0
fi

# Launch on each monitor
for monitor in $(hyprctl monitors -j 2>/dev/null | jq -r '.[] | .name'); do
  hyprctl dispatch focusmonitor "$monitor"
  
  alacritty --class="$WINDOW_CLASS" \
    -o colors.primary.background="0x000000" \
    -e "$SCREENSAVER_CMD"
  
  sleep 0.1
done
EOF

chmod +x ~/.local/bin/screensaver-launch
```

### Step 5: Configure Hyprland
```bash
# Add to ~/.config/hypr/hyprland.conf

# Window rules for screensaver
windowrule = fullscreen on, class:^(my.screensaver)$
windowrule = float on, class:^(my.screensaver)$
```

### Step 6: Configure Hypridle
```bash
# Create/edit ~/.config/hypr/hypridle.conf

general {
    lock_cmd = loginctl lock-session
}

listener {
    timeout = 150  # 2.5 minutes
    on-timeout = pidof hyprlock || ~/.local/bin/screensaver-launch
}
```

### Step 7: Test It!
```bash
# Test screensaver directly
~/.local/bin/screensaver-cmd

# Test launcher (launches on all monitors)
~/.local/bin/screensaver-launch

# Wait 150 seconds for automatic trigger
# Or trigger manually: ~/.local/bin/screensaver-launch
```

---

## 🎨 CUSTOMIZATION OPTIONS

### Change the ASCII Art
```bash
# Use different figlet font
echo "HELLO" | figlet -f big > ~/.config/screensaver/art.txt

# List available fonts
figlet -d /usr/share/figlet -l
```

### Change Animation Effects
```bash
# Edit screensaver-cmd and replace --random-effect with specific effect

# Available effects:
tte -i art.txt --effect-name matrix      # Matrix rain
tte -i art.txt --effect-name fireworks   # Fireworks
tte -i art.txt --effect-name rain        # Rain effect
tte -i art.txt --effect-name decrypt     # Decrypt effect
tte -i art.txt --effect-name synthgrid   # Grid effect
tte -i art.txt --effect-name blackhole   # Blackhole
tte -i art.txt --effect-name beams       # Light beams
tte -i art.txt --effect-name slide       # Slide in
tte -i art.txt --effect-name scattered   # Random scatter

# List all effects:
tte --list-effects
```

### Change Timeout Duration
```bash
# Edit ~/.config/hypr/hypridle.conf
listener {
    timeout = 300  # 5 minutes instead of 2.5
    on-timeout = ~/.local/bin/screensaver-launch
}
```

### Change Frame Rate
```bash
# Edit screensaver-cmd, change --frame-rate
--frame-rate 60   # Lower = less CPU usage
--frame-rate 120  # Default smooth
--frame-rate 240  # Ultra smooth, high CPU
```

### Change Canvas Settings
```bash
# In screensaver-cmd, adjust these options:
--canvas-width 0      # 0 = auto-detect, or specify: 80, 120, etc.
--canvas-height 0     # 0 = auto-detect
--anchor-canvas c     # c = center, tl = top-left, br = bottom-right, etc.
--anchor-text c       # Text position within canvas
--reuse-canvas        # Keep same canvas between renders (recommended)
```

---

## 🔍 TROUBLESHOOTING

### TTE Not Found
```bash
# Install it
sudo pacman -S python-terminaltexteffects
# or
pip install terminaltexteffects --user

# Verify installation
tte --version
```

### ASCII Art Not Found
```bash
mkdir -p ~/.config/screensaver
echo "TEST" | figlet > ~/.config/screensaver/art.txt
```

### Screensaver Not Triggering
```bash
# 1. Check if hypridle is running
pgrep hypridle || echo "Hypridle not running"

# 2. Start hypridle manually
hypridle &

# 3. Test launcher manually
~/.local/bin/screensaver-launch

# 4. Check logs
journalctl -xe
```

### Screensaver Won't Exit
```bash
# Kill all screensaver processes
pkill -f screensaver-cmd
pkill -x tte
pkill -f my.screensaver

# Restore cursor visibility
hyprctl keyword cursor:invisible false
```

### Multiple Instances
```bash
# Kill all but one
pkill -f my.screensaver
# Then restart
~/.local/bin/screensaver-launch
```

---

## 📊 TTE COMMAND BREAKDOWN

```bash
tte -i ~/.config/screensaver/art.txt \
    --frame-rate 120 \                # FPS (higher = smoother, more CPU)
    --canvas-width 0 \                # 0 = auto-detect terminal width
    --canvas-height 0 \               # 0 = auto-detect terminal height
    --reuse-canvas \                  # Reuse canvas (less flicker)
    --anchor-canvas c \               # Center canvas on screen
    --anchor-text c \                 # Center text within canvas
    --random-effect \                 # Pick random animation
    --exclude-effects dev_worm \       # Skip certain effects
    --no-eol \                        # No end-of-line newline
    --no-restore-cursor &             # Don't restore cursor position
```

---

## 📚 RELATED COMPONENTS

### Symphony Theme System
Your dotfiles include a complete theme system:
```
install/themes/symphony          ← Main theme switcher
install/themes/symphony-tui      ← TUI version
install/themes/symphony-import/  ← Import themes from GitHub
install/themes/hooks/            ← Apply theme to specific apps
```

### Theme Hooks (Auto-apply to apps)
- `00-alacritty.sh` - Terminal colors
- `00-ghostty.sh` - Ghostty terminal
- `00-kitty.sh` - Kitty terminal
- `10-gtk.sh` - GTK applications
- `10-hyprland.sh` - Window manager
- `10-rofi.sh` - Application launcher
- `20-btop.sh` - System monitor
- And many more...

---

## 💡 KEY TAKEAWAYS

1. **Simplicity** - Just a bash script running TTE in a terminal
2. **Multi-monitor** - Automatically scales to all displays
3. **Responsive** - Exits instantly on any input
4. **Customizable** - Change art, effects, timing easily
5. **Lightweight** - No GPU needed, pure terminal
6. **Integrated** - Works with Hyprland and Hypridle
7. **Themeable** - Matches your current color scheme
8. **Extensible** - Easy to modify or extend

---

## 🎯 NEXT STEPS

1. **Copy the scripts** to `~/.local/bin/`
2. **Create ASCII art** in `~/.config/screensaver/`
3. **Add window rules** to Hyprland config
4. **Configure hypridle** with timeout and trigger
5. **Test manually** with launcher script
6. **Wait for automatic** trigger after inactivity
7. **Customize** effects, art, and timing to your liking

