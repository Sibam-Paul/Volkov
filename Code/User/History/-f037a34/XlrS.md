# SYMPHONY SCREENSAVER - QUICK START & SUMMARY

## 🎯 TL;DR - 5 Minute Setup

```bash
# 1. Run the automatic setup script
chmod +x ~/setup-symphony-screensaver.sh
~/setup-symphony-screensaver.sh

# 2. Start hypridle
hypridle &

# 3. Test it
~/.local/bin/screensaver-launch

# 4. Wait 150 seconds for automatic trigger (or test manually)
```

Done! Your screensaver is now active.

---

## 📚 Documentation Created

I've created **4 comprehensive guides** for you:

### 1. **SYMPHONY_SCREENSAVER_GUIDE.md** ⭐ START HERE
- Complete implementation guide
- Step-by-step setup instructions
- Customization options
- Troubleshooting

### 2. **SYMPHONY_FLOW_DIAGRAMS.md**
- Visual flow diagrams
- Execution timeline
- File dependency graph
- State transitions
- Error handling flow

### 3. **SYMPHONY_COMPLETE_REFERENCE.md**
- Deep technical analysis
- Component breakdown
- Integration points
- Advanced customization
- Detailed troubleshooting

### 4. **setup-symphony-screensaver.sh** (Executable)
- Automated setup script
- Creates all necessary files
- Configures Hyprland & Hypridle
- Interactive output

---

## 🏗️ Architecture at a Glance

```
INACTIVITY (150s)
        ↓
HYPRIDLE.CONF
(Detects idle, triggers launcher)
        ↓
SCREENSAVER-LAUNCH
(Detects terminals, launches on each monitor)
        ↓
ALACRITTY/GHOSTTY/KITTY
(Terminal window with class: my.screensaver)
        ↓
HYPRLAND WINDOW RULES
(Makes window fullscreen)
        ↓
SCREENSAVER-CMD
(Main logic, monitors input, runs TTE)
        ↓
TTE (Terminal Text Effects)
(Animates ASCII art with random effects)
        ↓
USER INPUT / WINDOW FOCUS LOST
(Immediately exits screensaver)
        ↓
DESKTOP
(Returns to normal)
```

---

## 📂 File Structure

### Your Dotfiles
```
~/.dotfiles/
├── branding/
│   └── symphony.txt          ← Beautiful ASCII art
├── .config/hypr/
│   ├── hypridle.conf         ← Inactivity trigger
│   └── scripts/screensaver   ← Main screensaver logic
└── install/themes/
    ├── symphony              ← Theme switcher
    └── symphony-import/      ← Color importer
```

### Setup Creates
```
~/.local/bin/
├── screensaver-launch        ← Multi-monitor launcher
└── screensaver-cmd           ← Main command

~/.config/
├── screensaver/
│   └── art.txt              ← Your ASCII art
└── hypr/
    ├── hypridle.conf         ← Modified with screensaver config
    └── hyprland.conf         ← Modified with window rules

~/.local/state/screensaver/   ← State directory
```

---

## 🔑 Key Components Explained

### 1. Hypridle - Inactivity Detection
**What:** Daemon that monitors user activity
**When:** Runs continuously in background
**Trigger:** After 150 seconds of no keyboard/mouse input
**Action:** Executes screensaver-launch

### 2. Screensaver Launcher - Multi-Monitor Orchestrator
**What:** Bash script that launches screensaver
**Purpose:** Coordinates launch across all displays
**Detects:** Terminal type (Alacritty/Ghostty/Kitty)
**Action:** Spawns one terminal per monitor

### 3. Hyprland Window Rules - Auto Fullscreen
**What:** Window manager rules
**Purpose:** Makes screensaver fullscreen automatically
**Rules:**
- `windowrule = fullscreen on, class:^(my.screensaver)$`
- `windowrule = float on, class:^(my.screensaver)$`

### 4. Screensaver Command - Main Logic
**What:** Core bash script running in terminal
**Purpose:** Runs TTE with input monitoring
**Features:**
- Hides cursor
- Enables input tracking
- Monitors keyboard/mouse
- Monitors window focus
- Continuous effect cycling

### 5. TTE - Animation Engine
**What:** Terminal Text Effects (Python tool)
**Purpose:** Renders ASCII art with animations
**Features:**
- 100+ visual effects
- 120 FPS rendering
- Frame-rate adjustable
- Center-aligned display

### 6. ASCII Art - The Display
**What:** Text file containing your artwork
**Location:** `~/.config/screensaver/art.txt`
**Default:** Symphony (music-themed design)
**Customizable:** Use any figlet output or manual art

---

## ⚙️ How It Works - Simple Explanation

### User Idle → Screensaver Launches

```
1. User stops using keyboard/mouse
   ↓
2. Hypridle counts 150 seconds (2.5 minutes)
   ↓
3. Hypridle runs: screensaver-launch
   ↓
4. Launcher detects all monitors
   ↓
5. For each monitor:
   - Launch Alacritty terminal
   - Set window class: my.screensaver
   - Execute screensaver-cmd
   ↓
6. Hyprland sees window class my.screensaver
   - Applies window rule: fullscreen
   - Window goes fullscreen
   ↓
7. screensaver-cmd starts running
   - Hides cursor
   - Enables input tracking
   - Gets TTY
   ↓
8. screensaver-cmd runs TTE
   - Picks random effect
   - Animates ASCII art
   - 120 FPS rendering
   - Each effect ~5 seconds
   ↓
9. After effect finishes:
   - Checks for keyboard input
   - Checks if window has focus
   - If no input and still focused:
     → Loop to new random effect
   ↓
10. User presses ANY key or clicks elsewhere
    ↓
11. Input detected by read -n1
    - OR window focus lost detected
    ↓
12. exit_screensaver() called
    - Kill TTE process
    - Show cursor
    - Close screensaver windows
    ↓
13. Desktop restored
    User back to normal
```

---

## 🎨 Visual Effects Available

TTE includes 100+ effects. Popular ones:

| Effect | Description | CPU |
|--------|-------------|-----|
| **matrix** | Matrix rain effect | Medium |
| **fireworks** | Explosion effect | High |
| **rain** | Water droplets | Low |
| **decrypt** | Reveal/decrypt | Low |
| **synthgrid** | Grid pattern | Medium |
| **blackhole** | Gravity effect | High |
| **beams** | Light beams | Medium |
| **slide** | Text slides in | Low |
| **scattered** | Random positions | Low |
| **expand** | Growing/shrinking | Medium |
| **wave** | Wave motion | Medium |

See all effects: `tte --list-effects`

---

## 🔧 Customization Examples

### Change ASCII Art to Your Name
```bash
echo "YOUR NAME" | figlet -f banner > ~/.config/screensaver/art.txt
```

### Use Only Matrix Effect (No Random)
Edit `~/.local/bin/screensaver-cmd`:
```bash
# Change from:
--random-effect \

# To:
--effect-name matrix \
```

### Change Timeout to 5 Minutes
Edit `~/.config/hypr/hypridle.conf`:
```bash
# Change from:
timeout = 150

# To:
timeout = 300
```

### Lower CPU Usage
Edit `~/.local/bin/screensaver-cmd`:
```bash
# Change from:
--frame-rate 120 \

# To:
--frame-rate 60 \
```

### Prevent Screensaver from Running
```bash
mkdir -p ~/.local/state/screensaver
touch ~/.local/state/screensaver/disabled
```

Re-enable: `rm ~/.local/state/screensaver/disabled`

---

## 🚀 Usage

### Manual Triggers

```bash
# Test screensaver directly (instant)
~/.local/bin/screensaver-cmd

# Test on all monitors
~/.local/bin/screensaver-launch

# Kill screensaver if stuck
pkill -f my.screensaver; pkill -x tte
```

### Automatic Trigger

```bash
# Start hypridle (usually added to autostart)
hypridle &

# Add to ~/.config/hypr/hyprland.conf:
exec-once = hypridle
```

### Exit Methods

- **Press any key** - Keyboard input exits
- **Move mouse** - Mouse movement exits
- **Alt+Tab** - Window switch exits
- **Click elsewhere** - Focus loss exits
- **Ctrl+C** - Force exit

---

## ✅ Verification Checklist

After setup, verify everything works:

- [ ] ASCII art file exists: `cat ~/.config/screensaver/art.txt`
- [ ] Launcher script executable: `ls -l ~/.local/bin/screensaver-launch`
- [ ] Main command executable: `ls -l ~/.local/bin/screensaver-cmd`
- [ ] TTE installed: `which tte`
- [ ] Hyprland config has window rules: `grep my.screensaver ~/.config/hypr/hyprland.conf`
- [ ] Hypridle config has screensaver listener: `grep screensaver ~/.config/hypr/hypridle.conf`
- [ ] Hypridle is running: `pgrep hypridle`
- [ ] Test works: `~/.local/bin/screensaver-launch` (should display screensaver)

---

## 🐛 Common Issues

### Issue: Screensaver Won't Start
```bash
# Check if hypridle is running
pgrep hypridle

# Start it if not
hypridle &
```

### Issue: Screensaver Won't Exit
```bash
# Force kill all processes
pkill -f my.screensaver
pkill -x tte
hyprctl keyword cursor:invisible false
```

### Issue: TTE Not Found
```bash
# Install TTE
sudo pacman -S python-terminaltexteffects
# or
pip install terminaltexteffects
```

### Issue: Screensaver Won't Go Fullscreen
```bash
# Reload Hyprland config
hyprctl reload

# Check window rules are there
grep my.screensaver ~/.config/hypr/hyprland.conf
```

---

## 📖 For More Information

See the detailed guides:
- **SYMPHONY_SCREENSAVER_GUIDE.md** - Complete setup & customization
- **SYMPHONY_FLOW_DIAGRAMS.md** - Visual diagrams & flow charts
- **SYMPHONY_COMPLETE_REFERENCE.md** - Deep technical analysis

---

## 🎯 Success Criteria

You've successfully replicated the Symphony screensaver when:

✅ After 150 seconds of inactivity, screensaver automatically launches
✅ Screensaver displays fullscreen on all monitors
✅ ASCII art animates with visual effects (random or chosen)
✅ Pressing any key exits screensaver instantly
✅ Moving mouse exits screensaver
✅ Window focus loss exits screensaver
✅ You can customize art, effects, and timeout

---

## 💡 Pro Tips

1. **Use figlet for custom ASCII art:**
   ```bash
   figlet "YOUR TEXT" -f banner > ~/.config/screensaver/art.txt
   ```

2. **Test effects directly:**
   ```bash
   tte -i ~/.config/screensaver/art.txt --effect-name matrix
   ```

3. **Monitor CPU usage:**
   ```bash
   while true; do clear; tte --list-effects | wc -l; sleep 1; done
   ```

4. **Disable temporarily:**
   ```bash
   mkdir -p ~/.local/state/screensaver
   touch ~/.local/state/screensaver/disabled
   ```

5. **View all configuration:**
   ```bash
   echo "=== Hypridle ===" && grep -A5 timeout ~/.config/hypr/hypridle.conf
   echo "=== Hyprland ===" && grep my.screensaver ~/.config/hypr/hyprland.conf
   echo "=== Launcher ===" && head ~/.local/bin/screensaver-launch
   ```

---

## 🏁 Next Steps

1. **Run setup script:** `~/setup-symphony-screensaver.sh`
2. **Start hypridle:** `hypridle &`
3. **Test immediately:** `~/.local/bin/screensaver-launch`
4. **Test automatic trigger:** Wait 150 seconds of inactivity
5. **Customize:** Adjust art, effects, timeout to your preference
6. **Enjoy:** Beautiful screensaver on idle desktop!

---

**Created:** January 17, 2026
**Based on:** Your dotfiles Symphony Screensaver implementation
**Documentation:** 4 comprehensive guides + setup script
**Ready to use:** Yes! Run `~/setup-symphony-screensaver.sh`

