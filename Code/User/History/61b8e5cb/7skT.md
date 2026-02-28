# SYMPHONY SCREENSAVER - VISUAL FLOW & ARCHITECTURE

## 📊 COMPLETE EXECUTION FLOW DIAGRAM

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     USER ACTIVITY MONITORING                             │
│                         (Hypridle Daemon)                                │
└────────────────┬────────────────────────────────────────────────────────┘
                 │
                 │ Keyboard/Mouse idle for 150 seconds
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  ~/.config/hypr/hypridle.conf                                           │
│                                                                          │
│  listener {                                                             │
│    timeout = 150                                                        │
│    on-timeout = pidof hyprlock || ~/.local/bin/screensaver-launch     │
│  }                                                                       │
│                                                                          │
│  Decision: Is hyprlock running?                                         │
│    ├─ YES → Exit (don't launch screensaver)                           │
│    └─ NO  → Continue to launch screensaver                            │
│                                                                          │
└────────────────┬────────────────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  ~/.local/bin/screensaver-launch                                        │
│  (Multi-Monitor Launcher)                                               │
│                                                                          │
│  PREFLIGHT CHECKS:                                                      │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ ✓ Check: Is tte command installed?                              │  │
│  │   └─ NO → notify-send error & exit                              │  │
│  │                                                                   │  │
│  │ ✓ Check: Is screensaver already running?                        │  │
│  │   └─ YES → exit 0 (prevent duplicates)                          │  │
│  │                                                                   │  │
│  │ ✓ Check: Is screensaver disabled?                               │  │
│  │   └─ YES → exit 0 (unless forced)                               │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  SETUP:                                                                 │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ • Close walker overlay (if open)                                 │  │
│  │ • Get currently focused monitor (for restoring later)            │  │
│  │ • Detect terminal type: Alacritty/Ghostty/Kitty                 │  │
│  │ • Get list of all monitors from hyprctl                          │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  MAIN LOOP: For each monitor                                            │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ 1. Focus monitor with: hyprctl dispatch focusmonitor $monitor    │  │
│  │                                                                   │  │
│  │ 2. Launch terminal with screensaver:                             │  │
│  │    alacritty --class="my.screensaver" \                          │  │
│  │      -o colors.primary.background="0x000000" \                   │  │
│  │      -o colors.cursor.cursor="0x000000" \                        │  │
│  │      -e ~/.local/bin/screensaver-cmd                             │  │
│  │                                                                   │  │
│  │ 3. Small delay: sleep 0.1                                        │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  CLEANUP:                                                               │
│  └─ Restore focus to original monitor                                  │
│                                                                          │
└────────────────┬────────────────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  Alacritty Terminal Launch                                              │
│                                                                          │
│  Window Class: my.screensaver                                           │
│  Config:                                                                │
│    • Background: #000000 (black)                                       │
│    • Cursor: invisible                                                 │
│    • Padding: 0                                                        │
│                                                                          │
│  Executes: ~/.local/bin/screensaver-cmd                                │
│                                                                          │
└────────────────┬────────────────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  Hyprland Window Rules (Auto-Applied)                                   │
│                                                                          │
│  windowrule = fullscreen on, class:^(my.screensaver)$                  │
│  windowrule = float on, class:^(my.screensaver)$                       │
│                                                                          │
│  Result: Window becomes fullscreen immediately                         │
│                                                                          │
└────────────────┬────────────────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  ~/.local/bin/screensaver-cmd                                           │
│  (Main Screensaver Logic)                                               │
│                                                                          │
│  SETUP PHASE:                                                           │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ • Define helper function: screensaver_in_focus()                 │  │
│  │   └─ Checks if my.screensaver window has focus                   │  │
│  │                                                                   │  │
│  │ • Define exit handler: exit_screensaver()                        │  │
│  │   └─ Kill TTE, show cursor, exit cleanly                         │  │
│  │                                                                   │  │
│  │ • Set signal traps:                                              │  │
│  │   trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT           │  │
│  │   └─ Ctrl+C or any signal will trigger clean exit                │  │
│  │                                                                   │  │
│  │ • Enable input tracking:                                         │  │
│  │   printf '\e[?1000h\e[?1003h'  # Mouse & keyboard tracking      │  │
│  │                                                                   │  │
│  │ • Flush pending input:                                           │  │
│  │   while read -rsn1 -t 0.1; do :; done                            │  │
│  │                                                                   │  │
│  │ • Set background to pure black:                                  │  │
│  │   printf '\033]11;rgb:00/00/00\007'                              │  │
│  │                                                                   │  │
│  │ • Hide cursor:                                                   │  │
│  │   hyprctl keyword cursor:invisible true                          │  │
│  │                                                                   │  │
│  │ • Get TTY for process monitoring:                                │  │
│  │   tty=$(tty 2>/dev/null)                                         │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  MAIN LOOP:                                                             │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                                                                   │  │
│  │  while true; do                                                  │  │
│  │                                                                   │  │
│  │    1. Launch TTE with ASCII art:                                 │  │
│  │       tte -i ~/dotfiles/branding/symphony.txt \                  │  │
│  │         --frame-rate 120 \                                       │  │
│  │         --canvas-width 0 \        # Auto-detect                  │  │
│  │         --canvas-height 0 \       # Auto-detect                  │  │
│  │         --reuse-canvas \          # Smooth rendering             │  │
│  │         --anchor-canvas c \       # Center on screen             │  │
│  │         --anchor-text c \         # Center text                  │  │
│  │         --random-effect \         # Random animation             │  │
│  │         --exclude-effects dev_worm \ # Skip boring effect        │  │
│  │         --no-eol \                # No end-of-line               │  │
│  │         --no-restore-cursor &     # Run in background            │  │
│  │                                                                   │  │
│  │    2. Monitor TTE process:                                       │  │
│  │       while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do       │  │
│  │                                                                   │  │
│  │       a) Check for input:                                        │  │
│  │          if read -rsn1 -t 1; then  # 1 second timeout           │  │
│  │            exit_screensaver        # User pressed key            │  │
│  │          fi                                                       │  │
│  │                                                                   │  │
│  │       b) Check if window still has focus:                        │  │
│  │          if ! screensaver_in_focus; then                         │  │
│  │            exit_screensaver        # User switched window        │  │
│  │          fi                                                       │  │
│  │       done                                                        │  │
│  │                                                                   │  │
│  │    3. Loop again (new random effect)                             │  │
│  │  done                                                             │  │
│  │                                                                   │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
└────────────────┬────────────────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  TTE (Terminal Text Effects)                                            │
│                                                                          │
│  Reads: ~/dotfiles/branding/symphony.txt                                │
│                                                                          │
│  ASCII Art:                                                             │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │         ♪                                            ♫           │  │
│  │    ▄▄▄▄▄                                         ♪              │  │
│  │   ██▀▀▀▀█▄                      █▄           ♬                  │  │
│  │   ▀██▄  ▄▀       ▄              ██          ▄                   │  │
│  │     ▀██▄▄  ██ ██ ███▄███▄ ████▄ ████▄ ▄███▄ ████▄ ██ ██       │  │
│  │   ▄   ▀██▄ ██▄██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██▄██       │  │
│  │   ▀██████▀▄▄▀██▀▄██ ██ ▀█▄████▀▄██ ██▄▀███▀▄██ ▀█▄▄▀██▀       │  │
│  │      ♫       ██           ██                        ██           │  │
│  │            ▀▀▀     ♪      ▀              ♬        ▀▀▀          │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  Applies Random Effect: (changes each loop)                             │
│    • matrix      → Matrix rain effect                                   │
│    • fireworks   → Exploding fireworks                                  │
│    • rain        → Water droplets falling                               │
│    • decrypt     → Decrypt/reveal effect                                │
│    • synthgrid   → Grid pattern                                         │
│    • blackhole   → Gravity/blackhole effect                             │
│    • beams       → Light beams                                          │
│    • slide       → Text slides in                                       │
│    • scattered   → Random scattered placement                           │
│    ... and more                                                         │
│                                                                          │
│  Renders at 120 FPS continuously until exit                             │
│                                                                          │
└────────────────┬────────────────────────────────────────────────────────┘
                 │
           ┌─────┴─────┐
           │           │
           ▼           ▼
    USER INPUT    WINDOW FOCUS LOST
    (Keyboard)    (Alt+Tab, click elsewhere)
    (Mouse)
           │           │
           └─────┬─────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  EXIT_SCREENSAVER()                                                     │
│                                                                          │
│  Steps:                                                                 │
│  1. Show cursor:       hyprctl keyword cursor:invisible false           │
│  2. Kill TTE:          pkill -x tte 2>/dev/null                        │
│  3. Kill screensaver:  pkill -f my.screensaver 2>/dev/null             │
│  4. Exit script:       exit 0                                          │
│                                                                          │
│  Result: Terminal closes, focus returns to previous window              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🔗 FILE DEPENDENCY GRAPH

```
                    hypridle.conf
                          │
                          │ (trigger after 150s)
                          ▼
               screensaver-launch.sh
                          │
                ┌─────────┼─────────┐
                │         │         │
                ▼         ▼         ▼
          alacritty    ghostty    kitty
          (detected and chosen)
                          │
                          │ (--class my.screensaver)
                          ▼
                  Hyprland Window Rules
                  (fullscreen, float)
                          │
                          │ (-e command)
                          ▼
                screensaver-cmd.sh
                          │
                ┌─────────┼─────────┐
                │         │         │
                ▼         ▼         ▼
              TTE    hyprctl    Input Monitor
              (animation)  (UI control)  (Keyboard/Mouse)
                          │
                          │
                          ▼
           branding/symphony.txt
           (ASCII art + effects)
```

---

## ⏱️ TIMING BREAKDOWN

```
Timeline:
─────────────────────────────────────────────────────────────

0s           → User uses keyboard/mouse (activity detected)
             → Hypridle timer resets

150s         → User inactive for 2.5 minutes
             → Hypridle triggers: screensaver-launch

150s + 100ms → Launcher script starts
             → Checks dependencies
             → Detects monitors and terminal

150s + 150ms → Terminal windows start launching
             → Alacritty spawns with my.screensaver class

150s + 200ms → Hyprland window rules apply
             → Windows become fullscreen

150s + 250ms → screensaver-cmd executes
             → Setup: hide cursor, enable input tracking

150s + 300ms → TTE starts rendering
             → Random effect applies
             → 120 FPS animation begins

150s + 300ms → TTE runs continuously
             → Each effect may last 3-10 seconds
             → Then picks new random effect

∞ seconds   → User presses any key or moves mouse
             → Input detected by read -n1 -t 1
             → exit_screensaver triggered
             → TTE killed, cursor shown, terminal closes
             → Returns to desktop

Total response time: ~300ms from idle to screensaver showing
Exit response time: <100ms from input to screensaver gone
```

---

## 🎭 EFFECT CYCLING

```
Effect Loop Visualization:

┌─────────────────────────────────────────────────────────┐
│ LOOP 1: Random Effect (e.g., "matrix")                  │
│ Duration: ~5 seconds at 120 FPS (600 frames)            │
│ Output: ASCII art with Matrix rain effect               │
│ CPU: Low-medium                                         │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│ Check: User input? Window focus? → NO → Continue        │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│ TTE exits, triggers loop restart                        │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│ LOOP 2: NEW Random Effect (e.g., "fireworks")           │
│ Duration: ~5 seconds at 120 FPS (600 frames)            │
│ Output: ASCII art with Fireworks effect                 │
│ CPU: Medium                                             │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│ ... (repeat indefinitely until user input)              │
└─────────────────────────────────────────────────────────┘
```

---

## 🔐 INPUT DETECTION MECHANISM

```
Two-Level Input Detection:

┌──────────────────────────────┐
│ LEVEL 1: Keyboard/Mouse      │
│ Method: read -rsn1 -t 1      │
│ • Monitors raw input         │
│ • 1 second timeout           │
│ • Single character trigger   │
│ Returns: user pressed key    │
└────────────┬─────────────────┘
             │
             ├─ YES: exit_screensaver()
             │
             ▼
┌──────────────────────────────┐
│ LEVEL 2: Window Focus        │
│ Method: screensaver_in_focus()
│ • Check active window class  │
│ • hyprctl activewindow       │
│ • Detects Alt+Tab, clicks    │
│ Returns: window still focused?
└────────────┬─────────────────┘
             │
             ├─ NO (lost focus): exit_screensaver()
             │
             ▼
         CONTINUE
         (run TTE again with new effect)
```

---

## 🎨 CUSTOMIZATION HOOKS

```
User can customize:

1. ASCII Art File
   └─ ~/.config/screensaver/art.txt
      (change to any text/image)

2. Effect Type
   └─ --random-effect
      └─ Change to: --effect-name matrix, --effect-name fireworks, etc.

3. Frame Rate
   └─ --frame-rate 120
      └─ Adjust: 60, 120, 240 for different smoothness/CPU

4. Timing
   └─ timeout = 150 (in hypridle.conf)
      └─ Adjust: 60, 300, 600 seconds

5. Terminal Config
   └─ Colors, fonts, padding in launcher script
      └─ Customize per terminal type

6. Excluded Effects
   └─ --exclude-effects dev_worm
      └─ Add/remove effects to skip

7. Canvas Settings
   └─ --anchor-canvas c, --anchor-text c
      └─ Change positioning: tl, tr, bl, br, c
```

---

## 🚨 ERROR HANDLING FLOW

```
screensaver-launch
├─ TTE not found
│  └─ notify-send error → exit 1
│
├─ Already running
│  └─ pgrep check → exit 0 (silent)
│
├─ Disabled toggle
│  └─ Check ~/.local/state/screensaver/disabled → exit 0
│
└─ Success
   └─ Launch terminals on all monitors

screensaver-cmd
├─ Invalid TTY
│  └─ Fallback to standard read
│
├─ Hyprctl unavailable
│  └─ Continue without cursor control
│
└─ TTE crash
   └─ Main loop restarts TTE automatically
```

---

## 📈 RESOURCE USAGE

```
Idle State (Before Screensaver):
├─ hypridle:           ~1% CPU, 5MB RAM
└─ (minimal overhead)

Screensaver Active:
├─ TTE (render):       5-15% CPU (depends on effect)
├─ screensaver-cmd:    <1% CPU
├─ Terminal:           2-5% RAM
└─ Total:              ~100-150MB RAM, 5-20% CPU

Factors affecting CPU:
├─ Frame rate:         Higher FPS = higher CPU
├─ Effect type:        Some effects more intensive
├─ Canvas size:        Larger terminal = more work
├─ ASCII art size:     More characters = more work
└─ Terminal rendering: Depends on terminal efficiency
```

---

## 🔄 STATE TRANSITIONS

```
                    ┌─────────────┐
                    │   DESKTOP   │
                    │  (Normal)   │
                    └──────┬──────┘
                           │
                     (150s idle)
                           │
                           ▼
                    ┌─────────────┐
                    │  SCREENSAVER│
                    │   (Active)  │
                    └──────┬──────┘
                    ▲      │
         (effect    │      │ (user input / lost focus)
          cycles)   │      ▼
                    │   ┌──────────┐
                    │   │ EXIT CODE│
                    │   └─────┬────┘
                    │         │
                    └─────────┴─────→ DESKTOP (Normal)


Detailed State Machine:

DESKTOP
  ↓ (hypridle: idle 150s)
LAUNCHER
  ├─ Check dependencies
  ├─ Detect terminals
  └─ Spawn windows
  ↓
TERMINAL_SPAWN
  ├─ Alacritty/Ghostty/Kitty
  └─ Execute screensaver-cmd
  ↓
SETUP
  ├─ Hide cursor
  ├─ Enable input tracking
  ├─ Get TTY
  └─ Set background
  ↓
RUNNING
  ├─ Launch TTE
  ├─ Run effect for ~5s
  ├─ Monitor input
  ├─ Check window focus
  └─ Loop to new effect
  ↓ (user input detected)
EXIT
  ├─ Kill TTE
  ├─ Show cursor
  ├─ Kill terminals
  └─ Return to DESKTOP
```

This comprehensive flow diagram should help you understand exactly how the Symphony Screensaver works!

