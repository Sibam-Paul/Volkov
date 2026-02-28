# Omarchy Screensaver - Quick Start Guide

## What You Now Have

I've created a complete analysis and implementation of the Omarchy screensaver:

### 📄 Documentation Files:

1. **omarchy_screensaver_analysis.md** - Comprehensive guide with:
   - Complete architecture explanation
   - Step-by-step replication guide
   - Customization options
   - Troubleshooting tips

2. **screensaver_flow_diagram.txt** - Visual flow diagrams showing:
   - Execution flow
   - File dependencies
   - Process lifecycle
   - Signal handling

### 🚀 Ready-to-Use Scripts:

3. **screensaver-standalone.sh** - All-in-one screensaver script
4. **screensaver-launcher.sh** - Multi-monitor launcher

## How It Works (Summary)

```
User Idle (150s) 
    ↓
Hypridle triggers launcher
    ↓
Launcher opens terminal on each monitor
    ↓
Terminal runs screensaver command
    ↓
TTE displays animated ASCII art
    ↓
User input → Exit
```

## Quick Setup (5 Minutes)

### 1. Install Dependencies

```bash
# Arch Linux
sudo pacman -S python-terminaltexteffects hyprland hypridle alacritty jq

# Other systems
pip install terminaltexteffects
```

### 2. Create ASCII Art

```bash
mkdir -p ~/.config/screensaver

# Option A: Use figlet
figlet "YOUR NAME" > ~/.config/screensaver/art.txt

# Option B: Create manually or use Omarchy's icon
cp ~/omarchy/icon.txt ~/.config/screensaver/art.txt
```

### 3. Install Scripts

```bash
mkdir -p ~/.local/bin

# Copy the screensaver command
cp ~/screensaver-standalone.sh ~/.local/bin/screensaver-cmd
chmod +x ~/.local/bin/screensaver-cmd

# Copy the launcher
cp ~/screensaver-launcher.sh ~/.local/bin/screensaver-launch
chmod +x ~/.local/bin/screensaver-launch
```

### 4. Configure Hyprland

Add to `~/.config/hypr/hyprland.conf`:

```properties
# Window rules for screensaver
windowrule = fullscreen on, class:^(my.screensaver)$
windowrule = float on, class:^(my.screensaver)$
```

### 5. Configure Hypridle

Create/edit `~/.config/hypr/hypridle.conf`:

```properties
general {
    lock_cmd = loginctl lock-session
}

listener {
    timeout = 150  # 2.5 minutes
    on-timeout = ~/.local/bin/screensaver-launch
}
```

### 6. Start Hypridle

```bash
# Test hypridle
hypridle &

# Or add to Hyprland autostart
echo "exec-once = hypridle" >> ~/.config/hypr/hyprland.conf
```

## Test It Now!

```bash
# Test the screensaver directly
~/.local/bin/screensaver-cmd

# Test the launcher (launches on all monitors)
~/.local/bin/screensaver-launch

# Wait 2.5 minutes for automatic trigger
# (or manually trigger with the launcher)
```

## Key Technologies

- **TTE (Terminal Text Effects)** - The animation engine
- **Hyprland** - Wayland compositor for window management
- **Hypridle** - Detects user inactivity
- **Bash** - Orchestrates everything

## Core Concept

The screensaver is brilliantly simple:

1. **Just a terminal window** running fullscreen
2. **TTE animates ASCII art** with random effects (Matrix, Fireworks, etc.)
3. **Bash script monitors input** and exits immediately when detected
4. **Hyprland makes it fullscreen** automatically via window rules

No complex frameworks, no heavy graphics—just terminal + text effects!

## Customization

### Change the Art
```bash
# Use different ASCII art
echo "YOUR TEXT" | figlet -f banner > ~/.config/screensaver/art.txt
```

### Change the Effect
Edit `screensaver-cmd` and replace `--random-effect` with:
```bash
--effect-name matrix     # Matrix effect only
--effect-name fireworks  # Fireworks only
# Or keep --random-effect for variety
```

### Change Timeout
Edit `~/.config/hypr/hypridle.conf`:
```properties
listener {
    timeout = 300  # 5 minutes instead of 2.5
    on-timeout = ~/.local/bin/screensaver-launch
}
```

### List Available Effects
```bash
tte --list-effects
```

Some cool ones:
- matrix
- fireworks
- rain
- decrypt
- synthgrid
- blackhole
- beams
- slide
- scattered

## Troubleshooting

### "TTE not found"
```bash
# Install it
sudo pacman -S python-terminaltexteffects
# or
pip install terminaltexteffects
```

### "ASCII art file not found"
```bash
mkdir -p ~/.config/screensaver
echo "TEST" | figlet > ~/.config/screensaver/art.txt
```

### Screensaver not auto-starting
```bash
# Check if hypridle is running
ps aux | grep hypridle

# Start it
hypridle &

# Check the logs
journalctl --user -u hypridle -f
```

### Multiple instances
```bash
# Kill all
pkill -f my.screensaver
```

## Advanced Features

### Disable/Enable Screensaver
```bash
# Disable
mkdir -p ~/.local/state/screensaver
touch ~/.local/state/screensaver/disabled

# Enable
rm ~/.local/state/screensaver/disabled

# Force start even if disabled
~/.local/bin/screensaver-launch force
```

### Per-Monitor Customization
The launcher script launches a separate instance on each monitor. You can modify `screensaver-launcher.sh` to use different ASCII art per monitor.

## File Locations (Reference)

Original Omarchy locations:
- `/home/sibam/omarchy/bin/omarchy-launch-screensaver` - Launcher
- `/home/sibam/omarchy/bin/omarchy-cmd-screensaver` - Command
- `/home/sibam/omarchy/config/hypr/hypridle.conf` - Idle config
- `/home/sibam/omarchy/default/alacritty/screensaver.toml` - Terminal config
- `/home/sibam/omarchy/default/hypr/apps/system.conf` - Window rules

Your new locations:
- `~/.local/bin/screensaver-launch` - Your launcher
- `~/.local/bin/screensaver-cmd` - Your command
- `~/.config/screensaver/art.txt` - Your ASCII art
- `~/.config/hypr/hypridle.conf` - Your idle config
- `~/.config/hypr/hyprland.conf` - Your window rules

## What Makes This Cool

1. ✨ **Lightweight** - Just text effects, no GPU required
2. 🎨 **Beautiful** - Multiple animation effects
3. ⚡ **Responsive** - Exits instantly on input
4. 🖥️ **Multi-monitor** - Works across all displays
5. 🔧 **Customizable** - Change art, effects, timing
6. 🐧 **Pure Linux** - Uses Wayland/Hyprland features

## Next Steps

1. ✅ Read the full analysis: `omarchy_screensaver_analysis.md`
2. ✅ Study the flow: `screensaver_flow_diagram.txt`
3. ✅ Try the scripts: `screensaver-standalone.sh`
4. ✅ Customize to your liking!

## Questions?

The comprehensive guide in `omarchy_screensaver_analysis.md` has:
- Detailed explanations of every component
- Complete file-by-file breakdown
- Step-by-step replication instructions
- Customization examples
- Troubleshooting section

Enjoy your new screensaver! 🎉
