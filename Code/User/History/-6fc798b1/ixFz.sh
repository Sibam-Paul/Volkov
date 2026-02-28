#!/bin/bash
# SYMPHONY SCREENSAVER - QUICK START IMPLEMENTATION
# Copy this entire script and run it to setup the screensaver from scratch

set -e

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     SYMPHONY SCREENSAVER - SETUP SCRIPT                  ║"
echo "╚═══════════════════════════════════════════════════════════╝"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[✓]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
error() { echo -e "${RED}[✗]${RESET} $1"; exit 1; }

# ═════════════════════════════════════════════════════════════
# STEP 1: CHECK DEPENDENCIES
# ═════════════════════════════════════════════════════════════

info "Checking dependencies..."

missing_deps=()

for cmd in tte hyprctl jq bash; do
  if ! command -v "$cmd" &>/dev/null; then
    missing_deps+=("$cmd")
  fi
done

if [ ${#missing_deps[@]} -gt 0 ]; then
  error "Missing required commands: ${missing_deps[*]}"
fi

success "All dependencies found"

# ═════════════════════════════════════════════════════════════
# STEP 2: CREATE DIRECTORY STRUCTURE
# ═════════════════════════════════════════════════════════════

info "Creating directories..."

mkdir -p ~/.config/screensaver
mkdir -p ~/.local/bin
mkdir -p ~/.config/hypr/scripts
mkdir -p ~/.local/state/screensaver

success "Directories created"

# ═════════════════════════════════════════════════════════════
# STEP 3: CREATE ASCII ART
# ═════════════════════════════════════════════════════════════

info "Creating ASCII art..."

# Check if user wants to use figlet or copy from dotfiles
if command -v figlet &>/dev/null; then
  warn "figlet found - using it to generate art"
  echo "SYMPHONY" | figlet -f banner > ~/.config/screensaver/art.txt
  success "ASCII art created with figlet"
else
  warn "figlet not found - using default Symphony art"
  cat > ~/.config/screensaver/art.txt << 'ASCIIART'

        ♪                                            ♫
   ▄▄▄▄▄                                         ♪
  ██▀▀▀▀█▄                      █▄           ♬
  ▀██▄  ▄▀       ▄              ██          ▄
    ▀██▄▄  ██ ██ ███▄███▄ ████▄ ████▄ ▄███▄ ████▄ ██ ██
  ▄   ▀██▄ ██▄██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██▄██
  ▀██████▀▄▄▀██▀▄██ ██ ▀█▄████▀▄██ ██▄▀███▀▄██ ▀█▄▄▀██▀
     ♫       ██           ██                        ██
           ▀▀▀     ♪      ▀              ♬        ▀▀▀

ASCIIART
  success "ASCII art created"
fi

# ═════════════════════════════════════════════════════════════
# STEP 4: CREATE SCREENSAVER COMMAND SCRIPT
# ═════════════════════════════════════════════════════════════

info "Creating screensaver command script..."

cat > ~/.local/bin/screensaver-cmd << 'SCREENSAVER_CMD'
#!/bin/bash

###############################################################################
# SYMPHONY SCREENSAVER - MAIN COMMAND
# This is the core screensaver logic
###############################################################################

# Configuration
ASCII_ART="$HOME/.config/screensaver/art.txt"
WINDOW_CLASS="my.screensaver"
FRAME_RATE=120

# ─────────────────────────────────────────────────────────────
# HELPER: Check if screensaver window is in focus
# ─────────────────────────────────────────────────────────────
screensaver_in_focus() {
  hyprctl activewindow -j 2>/dev/null | \
    jq -e ".class == \"${WINDOW_CLASS}\"" >/dev/null 2>&1
}

# ─────────────────────────────────────────────────────────────
# HELPER: Clean exit handler
# ─────────────────────────────────────────────────────────────
exit_screensaver() {
  echo "Exiting screensaver..."
  
  # Show cursor
  hyprctl keyword cursor:invisible false &>/dev/null || true
  
  # Kill TTE process
  pkill -x tte 2>/dev/null || true
  
  # Kill screensaver windows
  pkill -f "$WINDOW_CLASS" 2>/dev/null || true
  
  exit 0
}

# ─────────────────────────────────────────────────────────────
# SETUP PHASE
# ─────────────────────────────────────────────────────────────

echo "Starting screensaver..."

# Set signal traps for clean exit
trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

# Enable mouse and keyboard input tracking
printf '\e[?1000h\e[?1003h'

# Flush any pending input to prevent immediate exit
while read -rsn1 -t 0.1; do :; done

# Set background to pure black
printf '\033]11;rgb:00/00/00\007'

# Hide cursor
hyprctl keyword cursor:invisible true &>/dev/null || true

# Get TTY for process monitoring
tty=$(tty 2>/dev/null)

# ─────────────────────────────────────────────────────────────
# MAIN LOOP - Run TTE continuously with random effects
# ─────────────────────────────────────────────────────────────

while true; do
  # Launch TTE with random effect
  tte -i "$ASCII_ART" \
    --frame-rate "$FRAME_RATE" \
    --canvas-width 0 \              # Auto-detect width
    --canvas-height 0 \             # Auto-detect height
    --reuse-canvas \                # Reuse canvas for smooth rendering
    --anchor-canvas c \             # Center canvas on screen
    --anchor-text c \               # Center text within canvas
    --random-effect \               # Pick random animation effect
    --exclude-effects dev_worm \    # Skip the dev_worm effect
    --no-eol \                      # No end-of-line character
    --no-restore-cursor &           # Don't restore cursor position

  # Get TTE process ID
  local tte_pid=$!

  # Monitor TTE process for input or window focus loss
  while pgrep -t "${tty#/dev/}" -x tte >/dev/null 2>&1; do
    # Check for any input (keyboard/mouse) with 1 second timeout
    if read -rsn1 -t 1 2>/dev/null; then
      exit_screensaver
    fi
    
    # Check if screensaver window still has focus
    if ! screensaver_in_focus; then
      exit_screensaver
    fi
  done

  # TTE finished naturally, loop will restart with new random effect
done
SCREENSAVER_CMD

chmod +x ~/.local/bin/screensaver-cmd
success "screensaver-cmd created"

# ═════════════════════════════════════════════════════════════
# STEP 5: CREATE LAUNCHER SCRIPT
# ═════════════════════════════════════════════════════════════

info "Creating launcher script..."

cat > ~/.local/bin/screensaver-launch << 'LAUNCHER_SCRIPT'
#!/bin/bash

###############################################################################
# SYMPHONY SCREENSAVER - MULTI-MONITOR LAUNCHER
# Launches screensaver on all monitors simultaneously
###############################################################################

SCREENSAVER_CMD="$HOME/.local/bin/screensaver-cmd"
WINDOW_CLASS="my.screensaver"
TERMINAL_CONFIG_DIR="$HOME/.config/screensaver"

# ─────────────────────────────────────────────────────────────
# PREFLIGHT CHECKS
# ─────────────────────────────────────────────────────────────

# Check if TTE is installed
if ! command -v tte &>/dev/null; then
  echo "ERROR: TTE (Terminal Text Effects) not installed"
  notify-send "Screensaver Error" "TTE not installed"
  exit 1
fi

# Check if screensaver is already running
if pgrep -f "$WINDOW_CLASS" >/dev/null 2>&1; then
  echo "Screensaver already running"
  exit 0
fi

# Check if screensaver is disabled (optional feature)
if [[ -f "$HOME/.local/state/screensaver/disabled" ]]; then
  echo "Screensaver is disabled"
  exit 0
fi

# ─────────────────────────────────────────────────────────────
# SETUP
# ─────────────────────────────────────────────────────────────

echo "Launching screensaver..."

# Get current focused monitor (for restoring later)
focused_monitor=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused == true).name' || echo "")

# Detect default terminal
terminal=$(xdg-terminal-exec --print-id 2>/dev/null || echo "Alacritty")

# ─────────────────────────────────────────────────────────────
# LAUNCH SCREENSAVER ON EACH MONITOR
# ─────────────────────────────────────────────────────────────

for monitor in $(hyprctl monitors -j 2>/dev/null | jq -r '.[] | .name' || echo ""); do
  echo "Launching screensaver on monitor: $monitor"
  
  # Focus the monitor
  hyprctl dispatch focusmonitor "$monitor" 2>/dev/null
  
  # Launch terminal with screensaver (terminal-specific config)
  case "$terminal" in
    *Alacritty*|*alacritty*)
      hyprctl dispatch exec -- \
        alacritty --class="$WINDOW_CLASS" \
        -o colors.primary.background="0x000000" \
        -o colors.cursor.cursor="0x000000" \
        -o font.size=18 \
        -o window.opacity=1.0 \
        -o window.padding.x=0 \
        -o window.padding.y=0 \
        -e "$SCREENSAVER_CMD"
      ;;
    
    *ghostty*|*Ghostty*)
      hyprctl dispatch exec -- \
        ghostty --class="$WINDOW_CLASS" \
        --font-size=18 \
        --background=000000 \
        -e "$SCREENSAVER_CMD"
      ;;
    
    *kitty*|*Kitty*)
      hyprctl dispatch exec -- \
        kitty --class="$WINDOW_CLASS" \
        --override font_size=18 \
        --override window_padding_width=0 \
        --override background=#000000 \
        -e "$SCREENSAVER_CMD"
      ;;
    
    *)
      # Fallback to Alacritty
      hyprctl dispatch exec -- \
        alacritty --class="$WINDOW_CLASS" \
        -o colors.primary.background="0x000000" \
        -e "$SCREENSAVER_CMD"
      ;;
  esac
  
  # Small delay to ensure window is created
  sleep 0.1
done

# Restore focus to original monitor
if [[ -n "$focused_monitor" ]]; then
  sleep 0.2
  hyprctl dispatch focusmonitor "$focused_monitor" 2>/dev/null || true
fi

echo "Screensaver launched successfully"
LAUNCHER_SCRIPT

chmod +x ~/.local/bin/screensaver-launch
success "screensaver-launch created"

# ═════════════════════════════════════════════════════════════
# STEP 6: ADD HYPRLAND WINDOW RULES
# ═════════════════════════════════════════════════════════════

info "Checking Hyprland configuration..."

HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

if [ -f "$HYPR_CONF" ]; then
  # Check if window rules already exist
  if ! grep -q "my.screensaver" "$HYPR_CONF" 2>/dev/null; then
    warn "Adding window rules to hyprland.conf..."
    cat >> "$HYPR_CONF" << 'HYPR_RULES'

# ─────────────────────────────────────────────────────────────
# SYMPHONY SCREENSAVER - Window Rules
# ─────────────────────────────────────────────────────────────
windowrule = fullscreen on, class:^(my.screensaver)$
windowrule = float on, class:^(my.screensaver)$
HYPR_RULES
    success "Window rules added"
  else
    success "Window rules already configured"
  fi
else
  warn "Hyprland config not found at $HYPR_CONF"
  info "Please add these window rules manually:"
  echo "  windowrule = fullscreen on, class:^(my.screensaver)$"
  echo "  windowrule = float on, class:^(my.screensaver)$"
fi

# ═════════════════════════════════════════════════════════════
# STEP 7: CREATE/UPDATE HYPRIDLE CONFIGURATION
# ═════════════════════════════════════════════════════════════

info "Checking Hypridle configuration..."

HYPRIDLE_CONF="$HOME/.config/hypr/hypridle.conf"

if [ ! -f "$HYPRIDLE_CONF" ]; then
  warn "Creating new hypridle.conf..."
  cat > "$HYPRIDLE_CONF" << 'HYPRIDLE_CONFIG'
general {
    lock_cmd = loginctl lock-session
    unlock_cmd = pkill -9 hyprlock
    before_sleep_cmd = loginctl lock-session
    ignore_dbus_inhibit = false
}

# Screensaver trigger: 150 seconds (2.5 minutes)
listener {
    timeout = 150
    on-timeout = pidof hyprlock || $HOME/.local/bin/screensaver-launch
    on-resume = pkill -f "my.screensaver" 2>/dev/null || true
}

# Lock screen trigger: 300 seconds (5 minutes)
listener {
    timeout = 300
    on-timeout = loginctl lock-session
    on-resume = pkill -9 hyprlock
}

# Sleep trigger: 900 seconds (15 minutes)
listener {
    timeout = 900
    on-timeout = systemctl suspend
}
HYPRIDLE_CONFIG
  success "hypridle.conf created"
else
  if grep -q "screensaver-launch" "$HYPRIDLE_CONF" 2>/dev/null; then
    success "Screensaver already configured in hypridle.conf"
  else
    warn "Adding screensaver config to hypridle.conf..."
    cat >> "$HYPRIDLE_CONF" << 'HYPRIDLE_CONFIG'

# Symphony Screensaver trigger: 150 seconds (2.5 minutes)
listener {
    timeout = 150
    on-timeout = pidof hyprlock || $HOME/.local/bin/screensaver-launch
    on-resume = pkill -f "my.screensaver" 2>/dev/null || true
}
HYPRIDLE_CONFIG
    success "Screensaver config added to hypridle.conf"
  fi
fi

# ═════════════════════════════════════════════════════════════
# STEP 8: TEST SETUP
# ═════════════════════════════════════════════════════════════

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     SETUP COMPLETE!                                       ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

success "All files created and configured"

echo ""
echo "${BLUE}NEXT STEPS:${RESET}"
echo ""
echo "1. Test the screensaver directly:"
echo "   ${GREEN}~/.local/bin/screensaver-cmd${RESET}"
echo ""
echo "2. Test the launcher (multi-monitor):"
echo "   ${GREEN}~/.local/bin/screensaver-launch${RESET}"
echo ""
echo "3. Start hypridle:"
echo "   ${GREEN}hypridle &${RESET}"
echo ""
echo "4. Wait 150 seconds (2.5 minutes) for automatic trigger"
echo "   or trigger manually with: ~/.local/bin/screensaver-launch"
echo ""
echo "${BLUE}CUSTOMIZATION:${RESET}"
echo ""
echo "• Change ASCII art:    ${GREEN}vim ~/.config/screensaver/art.txt${RESET}"
echo "• Change timeout:      ${GREEN}vim ~/.config/hypr/hypridle.conf${RESET}"
echo "• Change effects:      ${GREEN}vim ~/.local/bin/screensaver-cmd${RESET}"
echo "  Replace --random-effect with --effect-name matrix, etc."
echo ""
echo "${BLUE}LIST AVAILABLE EFFECTS:${RESET}"
echo "   ${GREEN}tte --list-effects${RESET}"
echo ""
echo "${YELLOW}TROUBLESHOOTING:${RESET}"
echo ""
echo "• Kill active screensaver:"
echo "  ${GREEN}pkill -f my.screensaver; pkill -x tte${RESET}"
echo ""
echo "• Check if hypridle is running:"
echo "  ${GREEN}pgrep hypridle${RESET}"
echo ""
echo "• View TTE options:"
echo "  ${GREEN}tte --help${RESET}"
echo ""

