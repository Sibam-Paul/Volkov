# SYMPHONY SCREENSAVER - COMPLETE ANALYSIS & REFERENCE

## 📑 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [File Analysis](#file-analysis)
3. [Component Breakdown](#component-breakdown)
4. [Execution Flow](#execution-flow)
5. [Integration Points](#integration-points)
6. [Customization Guide](#customization-guide)
7. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

### What is the Symphony Screensaver?

A **terminal-based animated screensaver** that:
- Displays beautiful ASCII art with dynamic visual effects
- Triggers automatically after user inactivity (150 seconds)
- Works seamlessly with Hyprland and Hypridle
- Exits instantly on any keyboard/mouse input
- Supports multi-monitor setups

### Technology Stack

| Component | Role | Technology |
|-----------|------|-----------|
| **Trigger** | Detect inactivity | `hypridle` (daemon) |
| **Launcher** | Multi-monitor orchestration | `bash` + `hyprctl` |
| **Terminal** | Container for screensaver | Alacritty/Ghostty/Kitty |
| **Animation** | Visual effects engine | `TTE` (Terminal Text Effects) |
| **UI Control** | Window management | `Hyprland` + window rules |
| **Art** | ASCII artwork | Text file |

### Key Technologies

**1. TTE (Terminal Text Effects)**
```
- Python-based CLI tool
- Package: python-terminaltexteffects
- Renders ASCII art with animations
- 100+ available effects
- Frame-rate adjustable
```

**2. Hypridle**
```
- Monitors user activity (keyboard, mouse)
- Detects inactivity periods
- Triggers actions after timeout
- Part of Hyprland ecosystem
```

**3. Hyprland Window Manager**
```
- Applies automatic window rules
- Makes screensaver fullscreen
- Floats the window
- Detects window focus changes
```

**4. Bash Scripting**
```
- Signal handling (SIGINT, SIGTERM)
- Input detection (read -n1)
- Process management (pgrep, pkill)
- TTY interaction
```

---

## File Analysis

### 1. **hypridle.conf** - Inactivity Detection
**Location:** `~/.config/hypr/hypridle.conf`

**Purpose:** Monitors system inactivity and triggers screensaver

**Configuration:**
```bash
listener {
    timeout = 150                    # 2.5 minutes of inactivity
    on-timeout = pidof hyprlock || ~/.local/bin/screensaver-launch
    on-resume = pkill -f my.screensaver
}
```

**How it works:**
1. Hypridle daemon runs continuously
2. Monitors keyboard and mouse input
3. Maintains activity timer
4. When timer reaches 150 seconds:
   - Checks if hyprlock is running (screen locked?)
   - If NOT locked → executes screensaver-launch
   - If locked → does nothing

---

### 2. **screensaver-launch** - Multi-Monitor Orchestrator
**Location:** `~/.local/bin/screensaver-launch`

**Purpose:** Coordinates screensaver launch across all monitors

**Key Functions:**

```bash
# PREFLIGHT CHECKS
- ✓ Check if TTE is installed
- ✓ Check if screensaver already running
- ✓ Check if screensaver is disabled

# DETECTION
- Detect terminal type (Alacritty/Ghostty/Kitty)
- Get list of connected monitors
- Get currently focused monitor

# LAUNCH
for each_monitor {
  - Focus the monitor with hyprctl
  - Launch terminal with screensaver class
  - Terminal-specific configuration
  - Execute screensaver-cmd
}

# CLEANUP
- Restore focus to original monitor
```

**Terminal-Specific Launches:**

```bash
# Alacritty
alacritty --class=my.screensaver \
  -o colors.primary.background="0x000000" \
  -o font.size=18 \
  -e ~/.local/bin/screensaver-cmd

# Ghostty
ghostty --class=my.screensaver \
  --font-size=18 \
  --background=000000 \
  -e ~/.local/bin/screensaver-cmd

# Kitty
kitty --class=my.screensaver \
  --override font_size=18 \
  --override background=#000000 \
  -e ~/.local/bin/screensaver-cmd
```

---

### 3. **screensaver-cmd** - Main Logic
**Location:** `~/.local/bin/screensaver-cmd` or `.config/hypr/scripts/screensaver`

**Purpose:** Core screensaver execution and input monitoring

**Execution Phases:**

**Phase 1: SETUP**
```bash
# Define helper functions
screensaver_in_focus()    # Check if window has focus
exit_screensaver()        # Cleanup and exit

# Set signal traps
trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

# Configure terminal
printf '\e[?1000h\e[?1003h'        # Enable mouse/keyboard tracking
printf '\033]11;rgb:00/00/00\007'  # Set background to black
while read -rsn1 -t 0.1; do :; done # Flush pending input

# Hide cursor
hyprctl keyword cursor:invisible true

# Get TTY for process monitoring
tty=$(tty 2>/dev/null)
```

**Phase 2: MAIN LOOP**
```bash
while true; do
  # Launch TTE with random effect
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

  # Monitor process
  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    # Check for input (1 second timeout)
    if read -rsn1 -t 1; then
      exit_screensaver
    fi
    
    # Check if window still focused
    if ! screensaver_in_focus; then
      exit_screensaver
    fi
  done
done
```

**Phase 3: EXIT**
```bash
exit_screensaver() {
  hyprctl keyword cursor:invisible false
  pkill -x tte
  pkill -f my.screensaver
  exit 0
}
```

---

### 4. **symphony.txt** - ASCII Art
**Location:** `~/dotfiles/branding/symphony.txt`

**Content:**
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
- Unicode characters (box drawing, musical notes)
- Center-aligned
- Perfect terminal aspect ratio
- Minimal (~10 lines)
- Scalable with any visual effect

---

### 5. **Hyprland Window Rules**
**Location:** `~/.config/hypr/hyprland.conf`

**Rules:**
```bash
windowrule = fullscreen on, class:^(my.screensaver)$
windowrule = float on, class:^(my.screensaver)$
```

**Effects:**
- Automatically applied when window is created
- No window decoration
- Full screen coverage
- Floating (not tiled)

---

### 6. **Symphony Theme System** (Bonus)
**Location:** `~/dotfiles/install/themes/`

**Files:**
```
symphony                    # Main theme switcher script
symphony-tui               # TUI version
symphony-import/
  ├── import.sh           # Import themes from GitHub
  ├── init.sh             # Initialization
  ├── terminals.sh        # Terminal color config
  ├── hyprland.sh         # Hyprland theme
  ├── gtk.sh              # GTK theme
  ├── waybar.sh           # Waybar config
  └── ...
```

**Purpose:** Manage color schemes across entire desktop

---

## Component Breakdown

### Hypridle Component
```
FUNCTION: Activity Detection
INPUT: Keyboard/Mouse events
TIMER: Counts inactivity seconds
TRIGGER: Executes command at timeout
OUTPUT: Launches screensaver-launch
STATE: Resets on any activity
```

**Configuration Variables:**
- `timeout` - Seconds before trigger (150 = 2.5 minutes)
- `on-timeout` - Command to execute
- `on-resume` - Command on activity resume

### Launcher Component
```
FUNCTION: Multi-monitor Coordination
INPUT: User inactivity signal from hypridle
PROCESS:
1. Dependency check (tte, hyprctl, jq)
2. Duplicate prevention (pgrep)
3. Terminal detection
4. Monitor enumeration (hyprctl)
5. Per-monitor launch
6. Focus restoration
OUTPUT: Screensaver windows on all monitors
```

**Critical Variables:**
- `SCREENSAVER_CMD` - Path to main command
- `WINDOW_CLASS` - Unique identifier for windows
- `TERMINAL_CONFIG_DIR` - Config directory

### Screensaver Command Component
```
FUNCTION: Animation & Input Detection
INPUT: TTY, signals, keyboard/mouse input
SIGNAL_HANDLERS:
- SIGINT (Ctrl+C)
- SIGTERM (kill)
- SIGHUP (terminal close)
- SIGQUIT (quit)

LOOP:
1. Run TTE with effect
2. Monitor for input (read -n1 -t 1)
3. Check window focus (hyprctl)
4. Restart with new effect or exit

OUTPUT: Animated screensaver display
EXIT_CONDITIONS:
- User presses any key
- User moves mouse
- User switches window
- System signal received
```

### TTE Component
```
FUNCTION: Text Animation Engine
INPUT:
- ASCII art file
- Frame rate (FPS)
- Canvas dimensions
- Effect type
- Text anchoring

PROCESS:
- Render ASCII art
- Apply effect (matrix, fireworks, rain, etc.)
- Display each frame
- Continue for ~3-10 seconds
- Exit and restart with new effect

OUTPUT: Animated visual effects in terminal
RESOURCES:
- CPU: 5-20% (effect-dependent)
- Memory: Minimal (~10MB)
- Dependencies: Python, curses
```

---

## Execution Flow

### Timeline (seconds)

```
0s       → User at desktop, activity detected
1s-150s  → User inactive, hypridle counting...
150s     → Timeout reached
         → Hypridle executes: screensaver-launch

150.05s  → screensaver-launch starts
         → Check dependencies: ✓
         → Check duplicates: ✓
         → Detect terminal: Alacritty

150.10s  → Get monitors: [HDMI-1, DP-2]
         → Focus HDMI-1
         → Launch Alacritty with --class my.screensaver

150.15s  → Alacritty window spawned
         → Hyprland applies window rules
         → Window becomes fullscreen

150.20s  → screensaver-cmd executes
         → Cursor hidden
         → Input tracking enabled
         → Get TTY: /dev/pts/5

150.25s  → TTE starts
         → Random effect selected: "matrix"
         → ASCII art displayed with animation

150.30s  → Screensaver displaying
         → 120 FPS rendering
         → Monitor for input every 1 second

∞        → TTE runs continuously
         → Each effect ~5-10 seconds
         → Transitions to random effect

∞+5s     → First effect finishes
         → Check input: none
         → Check focus: yes
         → Loop: new TTE with new effect

User     → Presses ANY key
         → read -rsn1 detects input
         → exit_screensaver() called
         → TTE killed
         → Cursor shown
         → Windows closed
         → Desktop restored
```

---

## Integration Points

### 1. Hyprland Integration
**Window Class:** `my.screensaver`
```bash
# Window rules must match class exactly
windowrule = fullscreen on, class:^(my.screensaver)$
```

**Commands:**
- `hyprctl dispatch focusmonitor` - Switch monitors
- `hyprctl dispatch exec` - Launch window
- `hyprctl activewindow` - Check active window
- `hyprctl keyword` - Change settings (cursor visibility)

### 2. Hypridle Integration
**Configuration Point:** `hypridle.conf`
```bash
listener {
    timeout = 150
    on-timeout = pidof hyprlock || screensaver-launch
}
```

**Logic:**
- Don't trigger if hyprlock is running
- Trigger only on timeout
- Clean up on activity resume

### 3. Terminal Integration
**Supported Terminals:**
- Alacritty (primary)
- Ghostty
- Kitty
- Fallback to Alacritty

**Launch Flags:**
- `--class` - Set window class for rules
- Background color - Set to black
- Font size - Optimize for display
- Padding - Remove for fullscreen effect

### 4. Input Monitoring
**Method 1: Keyboard Input**
```bash
read -rsn1 -t 1
```
- Raw input mode (-r)
- Single character (-s, -n1)
- 1 second timeout (-t 1)
- Returns on any key press

**Method 2: Window Focus**
```bash
hyprctl activewindow -j | jq '.class'
```
- Detects window switch
- Detects Alt+Tab
- Detects mouse click to different window

---

## Customization Guide

### 1. Change ASCII Art
```bash
# Option A: Use figlet
echo "YOUR TEXT" | figlet -f banner > ~/.config/screensaver/art.txt

# Option B: Create manually
cat > ~/.config/screensaver/art.txt << 'EOF'
    ╔════════════════╗
    ║  YOUR ASCII    ║
    ║     ART        ║
    ╚════════════════╝
EOF

# Option C: Use any existing art
cp ~/dotfiles/branding/symphony.txt ~/.config/screensaver/art.txt
```

### 2. Change Animation Effects
```bash
# View all available effects
tte --list-effects

# Popular effects:
- matrix       → Matrix rain
- fireworks    → Explosion effect
- rain         → Falling water
- decrypt      → Decryption reveal
- synthgrid    → Grid pattern
- blackhole    → Gravity effect
- beams        → Light beams
- slide        → Text slides in
- scattered    → Random positions
```

**Edit screensaver-cmd to use specific effect:**
```bash
# Original: random effect
--random-effect

# Change to: specific effect
--effect-name matrix
```

### 3. Change Timeout Duration
```bash
# Edit ~/.config/hypr/hypridle.conf
listener {
    timeout = 300  # 5 minutes instead of 2.5
    on-timeout = ~/.local/bin/screensaver-launch
}
```

**Common durations:**
- 60 seconds (1 minute) - Very fast
- 150 seconds (2.5 minutes) - Default
- 300 seconds (5 minutes) - Slow
- 600 seconds (10 minutes) - Very slow

### 4. Change Frame Rate
```bash
# Edit ~/.local/bin/screensaver-cmd

# Current:
--frame-rate 120

# Lower CPU usage:
--frame-rate 60    # Choppier animation, less CPU

# Ultra smooth:
--frame-rate 240   # Smooth animation, more CPU
```

**CPU Impact:**
- 60 FPS: ~5% CPU
- 120 FPS: ~10% CPU
- 240 FPS: ~20% CPU

### 5. Change Canvas Settings
```bash
# Edit ~/.local/bin/screensaver-cmd

# Canvas width (0 = auto-detect)
--canvas-width 0     → Auto-detect terminal width
--canvas-width 80    → Fixed 80 chars
--canvas-width 120   → Fixed 120 chars

# Canvas height (0 = auto-detect)
--canvas-height 0    → Auto-detect terminal height
--canvas-height 24   → Fixed 24 lines
--canvas-height 40   → Fixed 40 lines

# Canvas positioning
--anchor-canvas c    → Center
--anchor-canvas tl   → Top-left
--anchor-canvas br   → Bottom-right

# Text positioning
--anchor-text c      → Center within canvas
--anchor-text tl     → Top-left within canvas
```

### 6. Exclude Specific Effects
```bash
# Exclude one effect
--exclude-effects dev_worm

# Exclude multiple effects
--exclude-effects dev_worm,dev_foo,slow_effect
```

### 7. Terminal-Specific Customization

**Alacritty:**
```bash
alacritty --class=my.screensaver \
  -o colors.primary.background="0x000000" \
  -o colors.primary.foreground="0xFFFFFF" \
  -o font.size=18 \
  -o window.opacity=1.0 \
  -e screensaver-cmd
```

**Ghostty:**
```bash
ghostty --class=my.screensaver \
  --background=000000 \
  --foreground=FFFFFF \
  --font-size=18 \
  -e screensaver-cmd
```

**Kitty:**
```bash
kitty --class=my.screensaver \
  --override font_size=18 \
  --override background=#000000 \
  --override foreground=#FFFFFF \
  -e screensaver-cmd
```

---

## Troubleshooting

### Issue 1: Screensaver Won't Start
**Symptoms:**
- `hypridle` configured but screensaver not launching
- No visual feedback after inactivity

**Diagnosis:**
```bash
# Check if hypridle is running
pgrep hypridle
# → Should return PID

# Check if TTE is installed
which tte
# → Should show path

# Check if launcher is executable
ls -l ~/.local/bin/screensaver-launch
# → Should show -rwxr-xr-x
```

**Solutions:**
```bash
# 1. Start hypridle if not running
hypridle &

# 2. Install TTE if missing
sudo pacman -S python-terminaltexteffects
# or
pip install terminaltexteffects

# 3. Make scripts executable
chmod +x ~/.local/bin/screensaver-*

# 4. Test manually
~/.local/bin/screensaver-launch
```

### Issue 2: Screensaver Won't Exit
**Symptoms:**
- Screensaver shows but doesn't respond to input
- Can't get back to desktop

**Diagnosis:**
```bash
# Check processes
ps aux | grep screensaver
ps aux | grep tte

# Check active window
hyprctl activewindow -j | jq '.class'
```

**Solutions:**
```bash
# Kill all screensaver processes
pkill -f my.screensaver
pkill -x tte

# Restore cursor visibility
hyprctl keyword cursor:invisible false

# Return to desktop
# Alt+F2 or other WM hotkey
```

### Issue 3: Multiple Screensaver Instances
**Symptoms:**
- Multiple screensaver windows on one monitor
- Slow/laggy system

**Diagnosis:**
```bash
pgrep -f my.screensaver
# → Should show only a few PIDs, not many

ps aux | grep tte
# → Should show only 1-2 tte processes
```

**Solutions:**
```bash
# Kill all screensaver processes
pkill -f my.screensaver
pkill -x tte

# Check launcher script for bugs
cat ~/.local/bin/screensaver-launch | head -30

# Verify hypridle config
cat ~/.config/hypr/hypridle.conf | grep -A5 screensaver
```

### Issue 4: Screensaver Laggy/Choppy
**Symptoms:**
- Animation stutters
- High CPU usage
- Slow effect transitions

**Diagnosis:**
```bash
# Check frame rate setting
grep "frame-rate" ~/.local/bin/screensaver-cmd

# Monitor CPU usage
top  # Press 'o' to sort by CPU

# Check terminal font rendering
# (some fonts render slower)
```

**Solutions:**
```bash
# 1. Lower frame rate
# Edit screensaver-cmd:
--frame-rate 60    # Instead of 120

# 2. Use simpler effects
# Edit screensaver-cmd:
--effect-name rain    # Lighter than matrix

# 3. Exclude complex effects
--exclude-effects matrix,fireworks

# 4. Reduce canvas size
--canvas-width 80
--canvas-height 24
```

### Issue 5: TTE Not Found Error
**Symptoms:**
```
ERROR: TTE (Terminal Text Effects) not installed
```

**Solutions:**
```bash
# Arch Linux
sudo pacman -S python-terminaltexteffects

# Fedora
sudo dnf install terminaltexteffects

# Ubuntu/Debian
pip install terminaltexteffects --user

# Verify installation
tte --version
which tte
```

### Issue 6: ASCII Art Not Found
**Symptoms:**
```
ERROR: ASCII art file not found
```

**Solutions:**
```bash
# Create the directory
mkdir -p ~/.config/screensaver

# Create art with figlet
echo "YOUR TEXT" | figlet > ~/.config/screensaver/art.txt

# Or copy from dotfiles
cp ~/dotfiles/branding/symphony.txt ~/.config/screensaver/art.txt

# Verify
cat ~/.config/screensaver/art.txt
```

### Issue 7: Window Rules Not Applied
**Symptoms:**
- Screensaver not fullscreen
- Screensaver has decoration/title bar

**Solutions:**
```bash
# 1. Check window class matches
# In screensaver-launch:
--class=my.screensaver

# In hyprland.conf:
windowrule = fullscreen on, class:^(my.screensaver)$
# ↑ Must match exactly!

# 2. Reload Hyprland config
hyprctl reload

# 3. Verify rule is applied
hyprctl getrule my.screensaver
```

### Issue 8: Screensaver Triggers Too Often
**Symptoms:**
- Screensaver launches even during activity
- Timer resets randomly

**Solutions:**
```bash
# Check if hypridle is tracking input
pgrep hypridle
# → Must be running

# Verify timeout value in hypridle.conf
grep "timeout" ~/.config/hypr/hypridle.conf
# → Should be reasonable (150-600 seconds)

# Check if any other tool is interfering
pgrep xlock
pgrep xscreensaver
# → Kill if running alongside
```

---

## Quick Reference

### Commands Cheat Sheet

```bash
# Test screensaver directly
~/.local/bin/screensaver-cmd

# Test launcher (multi-monitor)
~/.local/bin/screensaver-launch

# Start hypridle
hypridle &

# Kill screensaver
pkill -f my.screensaver
pkill -x tte

# Show cursor
hyprctl keyword cursor:invisible false

# List TTE effects
tte --list-effects

# View ASCII art
cat ~/.config/screensaver/art.txt

# Edit launcher
vim ~/.local/bin/screensaver-launch

# Edit main command
vim ~/.local/bin/screensaver-cmd

# Edit hypridle config
vim ~/.config/hypr/hypridle.conf

# Edit hyprland config
vim ~/.config/hypr/hyprland.conf
```

### File Paths Reference

```bash
ASCII Art:           ~/.config/screensaver/art.txt
Launcher Script:     ~/.local/bin/screensaver-launch
Main Command:        ~/.local/bin/screensaver-cmd
Hypridle Config:     ~/.config/hypr/hypridle.conf
Hyprland Config:     ~/.config/hypr/hyprland.conf
Screensaver State:   ~/.local/state/screensaver/
```

### Configuration Summary

| Setting | File | Default | Range |
|---------|------|---------|-------|
| Timeout | hypridle.conf | 150s | 30-900s |
| Frame Rate | screensaver-cmd | 120 FPS | 30-300 FPS |
| Canvas Width | screensaver-cmd | 0 (auto) | 0, 40-200 |
| Canvas Height | screensaver-cmd | 0 (auto) | 0, 20-100 |
| Effect Type | screensaver-cmd | random | 100+ effects |
| Terminal | system | Alacritty | Alacritty/Ghostty/Kitty |

