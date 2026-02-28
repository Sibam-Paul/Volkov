# Omarchy Screensaver - Complete Analysis & Implementation Guide

## Overview
The Omarchy screensaver is a terminal-based screensaver that uses **TTE (Terminal Text Effects)** to display animated ASCII art with various visual effects. It launches automatically after inactivity and exits on any user input.

---

## Architecture & File Flow

```
┌─────────────────────────────────────────────────────────────┐
│                   TRIGGER (Inactivity)                       │
│                hypridle.conf (150s timeout)                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              LAUNCHER SCRIPT                                 │
│        bin/omarchy-launch-screensaver                        │
│  - Detects which terminal (Alacritty/Ghostty/Kitty)        │
│  - Launches terminal on each monitor                         │
│  - Loads terminal-specific config                            │
│  - Executes omarchy-cmd-screensaver                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│           SCREENSAVER EXECUTION                              │
│         bin/omarchy-cmd-screensaver                          │
│  - Hides cursor                                              │
│  - Runs TTE with random effects                              │
│  - Monitors for keyboard/mouse input                         │
│  - Exits on any interaction                                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              TTE (Terminal Text Effects)                     │
│  - Renders ASCII art with animations                         │
│  - Random effects (Matrix, Fireworks, etc.)                  │
│  - Runs at 120 FPS                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## Key Components

### 1. **Hypridle Configuration** (`config/hypr/hypridle.conf`)
- **Role**: Monitors user inactivity and triggers actions
- **Screensaver Timeout**: 150 seconds (2.5 minutes)
- **Action**: Launches `omarchy-launch-screensaver` if not already locked

```properties
listener {
    timeout = 150
    on-timeout = pidof hyprlock || omarchy-launch-screensaver
}
```

### 2. **Launcher Script** (`bin/omarchy-launch-screensaver`)
**Purpose**: Orchestrates the screensaver launch across all monitors

**Flow**:
1. ✅ Check if `tte` command exists
2. ✅ Prevent duplicate instances (check if already running)
3. ✅ Check if screensaver is disabled via toggle file
4. ✅ Close Walker overlay if open
5. ✅ Detect current focused monitor
6. 🔁 For each monitor:
   - Focus the monitor
   - Detect terminal type (Alacritty/Ghostty/Kitty)
   - Launch terminal with:
     - Class: `org.omarchy.screensaver`
     - Custom config file
     - Execute: `omarchy-cmd-screensaver`
7. ↩️ Return focus to original monitor

**Terminal-Specific Launches**:

```bash
# Alacritty
alacritty --class=org.omarchy.screensaver \
  --config-file ~/.local/share/omarchy/default/alacritty/screensaver.toml \
  -e omarchy-cmd-screensaver

# Ghostty
ghostty --class=org.omarchy.screensaver \
  --config-file=~/.local/share/omarchy/default/ghostty/screensaver \
  --font-size=18 \
  -e omarchy-cmd-screensaver

# Kitty
kitty --class=org.omarchy.screensaver \
  --override font_size=18 \
  --override window_padding_width=0 \
  -e omarchy-cmd-screensaver
```

### 3. **Screensaver Command** (`bin/omarchy-cmd-screensaver`)
**Purpose**: Main screensaver logic

**Key Features**:
- **Input Detection**: Monitors for any keyboard/mouse input
- **Cursor Management**: Hides cursor during screensaver
- **Process Management**: Continuous loop with TTE
- **Exit Handling**: Traps signals (SIGINT, SIGTERM, etc.)

**Flow**:
```bash
1. Set background to black: printf '\033]11;rgb:00/00/00\007'
2. Hide cursor: hyprctl keyword cursor:invisible true
3. Loop:
   - Run TTE with random effect on ASCII art
   - Monitor for input (read -n1 -t 1)
   - Check if screensaver window is still focused
   - Exit if input detected or lost focus
4. On exit:
   - Show cursor
   - Kill TTE process
   - Kill all screensaver windows
```

**TTE Command**:
```bash
tte -i ~/.config/omarchy/branding/screensaver.txt \
  --frame-rate 120 \
  --canvas-width 0 \
  --canvas-height 0 \
  --reuse-canvas \
  --anchor-canvas c \
  --anchor-text c \
  --random-effect \
  --exclude-effects dev_worm \
  --no-eol \
  --no-restore-cursor
```

### 4. **Terminal Configurations**

**Alacritty** (`default/alacritty/screensaver.toml`):
```toml
[colors.primary]
background = "0x000000"

[colors.cursor]
cursor = "0x000000"

[font]
size = 18.0

[window]
opacity = 1.0
```

**Ghostty** (`default/ghostty/screensaver`):
```
window-padding-x = 0
window-padding-y = 0
window-padding-color = "extend-always"
```

### 5. **Hyprland Window Rules** (`default/hypr/apps/system.conf`)
```properties
# Fullscreen screensaver
windowrule = fullscreen on, match:class org.omarchy.screensaver
windowrule = float on, match:class org.omarchy.screensaver
```

### 6. **ASCII Art** (Text to Display)
The screensaver displays ASCII art from:
- **Main**: `~/.config/omarchy/branding/screensaver.txt`
- **Fallback**: Can use `icon.txt` or custom text

Example (simplified):
```
░██    ░██ ░██     ░██ ░█████████  ░██    ░██ 
░██    ░██  ░██   ░██  ░██     ░██  ░██  ░██  
   ...
```

---

## Dependencies

1. **TTE (Terminal Text Effects)**
   - Package: `python-terminaltexteffects`
   - Command: `tte`
   - Purpose: Renders animated text effects

2. **Terminal Emulator** (one of):
   - Alacritty
   - Ghostty  
   - Kitty

3. **Hyprland**
   - Wayland compositor
   - Required for window management

4. **Hypridle**
   - Idle daemon for Hyprland
   - Triggers screensaver on inactivity

5. **System Utilities**:
   - `jq` - JSON parsing
   - `hyprctl` - Hyprland control
   - `pgrep`/`pkill` - Process management

---

## How to Replicate

### Step 1: Install Dependencies

```bash
# Install TTE
sudo pacman -S python-terminaltexteffects  # Arch Linux
# or
pip install terminaltexteffects

# Install a supported terminal
sudo pacman -S alacritty  # or ghostty or kitty

# Install Hyprland and hypridle (if not already)
sudo pacman -S hyprland hypridle
```

### Step 2: Create Directory Structure

```bash
mkdir -p ~/.config/screensaver
mkdir -p ~/.local/bin
```

### Step 3: Create ASCII Art File

```bash
cat > ~/.config/screensaver/art.txt << 'EOF'
░██    ░██ ░██     ░██ ░█████████  ░██    ░██ 
░██    ░██  ░██   ░██  ░██     ░██  ░██  ░██  
░██    ░██   ░██ ░██   ░██     ░██   ░██░██   
░██    ░██    ░████    ░█████████     ░███    
 ░██  ░██      ░██     ░██   ░██     ░██░██   
  ░██░██       ░██     ░██    ░██   ░██  ░██  
   ░███        ░██     ░██     ░██ ░██    ░██ 
EOF
```

### Step 4: Create Screensaver Command Script

```bash
cat > ~/.local/bin/screensaver-cmd << 'SCRIPT'
#!/bin/bash

screensaver_in_focus() {
  hyprctl activewindow -j | jq -e '.class == "my.screensaver"' >/dev/null 2>&1
}

exit_screensaver() {
  hyprctl keyword cursor:invisible false &>/dev/null || true
  pkill -x tte 2>/dev/null
  pkill -f my.screensaver 2>/dev/null
  exit 0
}

trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

printf '\033]11;rgb:00/00/00\007'
hyprctl keyword cursor:invisible true &>/dev/null

tty=$(tty 2>/dev/null)

while true; do
  tte -i ~/.config/screensaver/art.txt \
    --frame-rate 120 --canvas-width 0 --canvas-height 0 \
    --reuse-canvas --anchor-canvas c --anchor-text c \
    --random-effect --exclude-effects dev_worm \
    --no-eol --no-restore-cursor &

  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    if read -n1 -t 1 || ! screensaver_in_focus; then
      exit_screensaver
    fi
  done
done
SCRIPT

chmod +x ~/.local/bin/screensaver-cmd
```

### Step 5: Create Launcher Script

```bash
cat > ~/.local/bin/screensaver-launch << 'SCRIPT'
#!/bin/bash

if ! command -v tte &>/dev/null; then
  echo "TTE not installed"
  exit 1
fi

pgrep -f my.screensaver && exit 0

focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')

for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
  hyprctl dispatch focusmonitor $m
  hyprctl dispatch exec -- \
    alacritty --class=my.screensaver \
    -o colors.primary.background="0x000000" \
    -o font.size=18 \
    -o window.opacity=1.0 \
    -e ~/.local/bin/screensaver-cmd
done

hyprctl dispatch focusmonitor $focused
SCRIPT

chmod +x ~/.local/bin/screensaver-launch
```

### Step 6: Configure Hyprland Window Rules

Add to `~/.config/hypr/hyprland.conf`:

```properties
windowrule = fullscreen on, class:^(my.screensaver)$
windowrule = float on, class:^(my.screensaver)$
```

### Step 7: Configure Hypridle

Create/edit `~/.config/hypr/hypridle.conf`:

```properties
general {
    lock_cmd = loginctl lock-session
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = 150  # 2.5 minutes
    on-timeout = ~/.local/bin/screensaver-launch
}

listener {
    timeout = 300  # 5 minutes
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}
```

### Step 8: Start Hypridle

```bash
# Add to Hyprland autostart
echo "exec-once = hypridle" >> ~/.config/hypr/hyprland.conf

# Or start manually
hypridle &
```

### Step 9: Test Manually

```bash
# Test the screensaver command
~/.local/bin/screensaver-cmd

# Test the launcher
~/.local/bin/screensaver-launch
```

---

## Customization Options

### Change ASCII Art
Replace `~/.config/screensaver/art.txt` with your own ASCII art:
```bash
figlet "MY TEXT" > ~/.config/screensaver/art.txt
```

### Change Effects
Modify the TTE command in `screensaver-cmd`:
```bash
# Use specific effect instead of random
--effect-name matrix

# List available effects
tte --list-effects

# Change frame rate (smoother/faster)
--frame-rate 240
```

### Change Timeout
Edit `hypridle.conf`:
```properties
listener {
    timeout = 300  # 5 minutes instead of 2.5
    on-timeout = ~/.local/bin/screensaver-launch
}
```

### Disable on Demand
```bash
# Create toggle file
mkdir -p ~/.local/state/screensaver
touch ~/.local/state/screensaver/disabled

# Re-enable
rm ~/.local/state/screensaver/disabled
```

---

## TTE Effects Available

Some popular effects you can use:
- `matrix` - Matrix-style falling characters
- `fireworks` - Firework explosions
- `rain` - Falling rain effect
- `slide` - Sliding text
- `decrypt` - Decryption animation
- `synthgrid` - Retro synthwave grid
- `blackhole` - Text being sucked into a black hole
- `scattered` - Scattered characters assembling
- `beams` - Light beam effects

Use `tte --list-effects` for the complete list.

---

## Troubleshooting

### Screensaver Not Starting
```bash
# Check if hypridle is running
ps aux | grep hypridle

# Check if TTE is installed
which tte

# Test manually
~/.local/bin/screensaver-launch
```

### Cursor Not Hiding
```bash
# Hyprland might not support cursor hiding
# Alternative: use TTE's built-in cursor hiding
```

### Multiple Instances Running
```bash
# Kill all screensaver instances
pkill -f my.screensaver
```

### Wrong Terminal Opens
Update the launcher script to use your preferred terminal (Ghostty or Kitty instead of Alacritty).

---

## Advanced Features

### Multi-Monitor Support
The Omarchy implementation launches a separate screensaver window on each monitor. This is handled in the launcher script loop.

### Toggle On/Off
```bash
# Add toggle check to launcher
if [[ -f ~/.local/state/screensaver/disabled ]]; then
  exit 1
fi
```

### Force Start
```bash
# Add force parameter
if [[ $1 == "force" ]]; then
  # Skip toggle check
fi
```

---

## Summary

The Omarchy screensaver is a elegant solution that:
1. ✅ Uses terminal + TTE for lightweight animation
2. ✅ Integrates with Hyprland's idle management
3. ✅ Supports multiple monitors
4. ✅ Responds instantly to user input
5. ✅ Customizable with various effects and ASCII art

The beauty is in its simplicity - it's just a terminal window running an animated text effect, made fullscreen and triggered automatically. No complex dependencies or heavy graphics frameworks needed!
