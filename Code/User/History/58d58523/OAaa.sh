#!/bin/bash
# Simplified Omarchy Screensaver Implementation
# This is a standalone version you can use immediately

#####################################################################
# CONFIGURATION - Edit these to customize
#####################################################################

# Path to your ASCII art file (create this with your design)
ASCII_ART_FILE="$HOME/.config/screensaver/art.txt"

# Window class for identification
WINDOW_CLASS="my.screensaver"

# TTE frame rate (higher = smoother, more CPU)
FRAME_RATE=120

# Font size
FONT_SIZE=18

# Effects to exclude (space-separated)
EXCLUDE_EFFECTS="dev_worm"

#####################################################################
# HELPER FUNCTIONS
#####################################################################

# Check if screensaver window is currently focused
screensaver_in_focus() {
  hyprctl activewindow -j 2>/dev/null | \
    jq -e ".class == \"${WINDOW_CLASS}\"" >/dev/null 2>&1
}

# Clean exit handler
exit_screensaver() {
  echo "Exiting screensaver..."
  
  # Restore cursor
  hyprctl keyword cursor:invisible false &>/dev/null || true
  
  # Kill TTE process
  pkill -x tte 2>/dev/null || true
  
  # Kill all screensaver windows
  pkill -f "${WINDOW_CLASS}" 2>/dev/null || true
  
  exit 0
}

# Check if required commands exist
check_dependencies() {
  local missing=()
  
  for cmd in tte hyprctl jq pgrep pkill; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done
  
  if [ ${#missing[@]} -gt 0 ]; then
    echo "ERROR: Missing required commands: ${missing[*]}"
    echo ""
    echo "Install with:"
    echo "  sudo pacman -S python-terminaltexteffects hyprland jq procps-ng"
    exit 1
  fi
}

# Check if ASCII art file exists
check_ascii_art() {
  if [ ! -f "$ASCII_ART_FILE" ]; then
    echo "ERROR: ASCII art file not found: $ASCII_ART_FILE"
    echo ""
    echo "Create it with:"
    echo "  mkdir -p $(dirname "$ASCII_ART_FILE")"
    echo "  figlet 'YOUR TEXT' > $ASCII_ART_FILE"
    echo ""
    echo "Or use the sample below:"
    cat << 'EOF'
cat > "$ASCII_ART_FILE" << 'ASCIIART'
░██    ░██ ░██     ░██ ░█████████  ░██    ░██ 
░██    ░██  ░██   ░██  ░██     ░██  ░██  ░██  
░██    ░██   ░██ ░██   ░██     ░██   ░██░██   
░██    ░██    ░████    ░█████████     ░███    
 ░██  ░██      ░██     ░██   ░██     ░██░██   
  ░██░██       ░██     ░██    ░██   ░██  ░██  
   ░███        ░██     ░██     ░██ ░██    ░██ 
ASCIIART
EOF
    exit 1
  fi
}

#####################################################################
# MAIN SCREENSAVER LOGIC
#####################################################################

main() {
  echo "Starting Omarchy-style screensaver..."
  
  # Check dependencies
  check_dependencies
  check_ascii_art
  
  # Set up signal handlers for clean exit
  trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT EXIT
  
  # Configure terminal appearance
  printf '\033]11;rgb:00/00/00\007'  # Set background to black
  
  # Hide cursor
  hyprctl keyword cursor:invisible true &>/dev/null
  
  # Get current TTY for process monitoring
  local tty
  tty=$(tty 2>/dev/null)
  
  echo "Screensaver active. Press any key to exit..."
  
  # Main loop - continuously run TTE with random effects
  while true; do
    # Launch TTE with random effect in background
    tte -i "$ASCII_ART_FILE" \
      --frame-rate "$FRAME_RATE" \
      --canvas-width 0 \
      --canvas-height 0 \
      --reuse-canvas \
      --anchor-canvas c \
      --anchor-text c \
      --random-effect \
      --exclude-effects "$EXCLUDE_EFFECTS" \
      --no-eol \
      --no-restore-cursor &
    
    # Monitor TTE process
    while pgrep -t "${tty#/dev/}" -x tte >/dev/null 2>&1; do
      # Check for keyboard input (1 second timeout)
      if read -n1 -t 1; then
        exit_screensaver
      fi
      
      # Check if screensaver window still has focus
      if ! screensaver_in_focus; then
        exit_screensaver
      fi
    done
    
    # TTE finished, loop will restart with a new random effect
  done
}

#####################################################################
# ENTRY POINT
#####################################################################

main "$@"
