#!/bin/bash
# Omarchy Screensaver Launcher
# Launches the screensaver on all monitors

#####################################################################
# CONFIGURATION
#####################################################################

SCREENSAVER_CMD="$HOME/.local/bin/screensaver-cmd"
WINDOW_CLASS="my.screensaver"
TERMINAL_CONFIG_DIR="$HOME/.config/screensaver"

#####################################################################
# PREFLIGHT CHECKS
#####################################################################

# Check if TTE is installed
if ! command -v tte &>/dev/null; then
  notify-send "Screensaver Error" "TTE (Terminal Text Effects) not installed"
  exit 1
fi

# Check if screensaver is already running
if pgrep -f "$WINDOW_CLASS" >/dev/null; then
  echo "Screensaver already running"
  exit 0
fi

# Check for disable toggle (optional feature)
if [[ -f "$HOME/.local/state/screensaver/disabled" ]] && [[ "$1" != "force" ]]; then
  echo "Screensaver is disabled"
  exit 0
fi

#####################################################################
# SETUP
#####################################################################

# Close any overlays (optional - comment out if not using walker)
# walker -q 2>/dev/null || true

# Get current focused monitor
focused=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused == true).name')

# Detect terminal emulator
terminal=$(xdg-terminal-exec --print-id 2>/dev/null || echo "Alacritty")

#####################################################################
# LAUNCH SCREENSAVER ON EACH MONITOR
#####################################################################

for monitor in $(hyprctl monitors -j 2>/dev/null | jq -r '.[] | .name'); do
  echo "Launching screensaver on monitor: $monitor"
  
  # Focus the monitor
  hyprctl dispatch focusmonitor "$monitor" 2>/dev/null
  
  # Launch terminal with screensaver based on terminal type
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
        -o font.size=18 \
        -e "$SCREENSAVER_CMD"
      ;;
  esac
  
  # Small delay to ensure window is created
  sleep 0.1
done

#####################################################################
# RESTORE FOCUS
#####################################################################

# Return focus to original monitor
if [ -n "$focused" ]; then
  hyprctl dispatch focusmonitor "$focused" 2>/dev/null
fi

echo "Screensaver launched on all monitors"
