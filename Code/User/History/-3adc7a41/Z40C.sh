#!/bin/bash
# OMARCHY SCREENSAVER INTEGRATION SCRIPT
# Safe implementation without modifying existing configs

set -e

CONFIG_DIR="$HOME/.config/hypr"
LOCAL_BIN="$HOME/.local/bin"
SCREENSAVER_CONFIG="$HOME/.config/screensaver"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     OMARCHY SCREENSAVER INTEGRATION SETUP                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check dependencies
echo "📋 Checking dependencies..."
MISSING=()

for cmd in hyprctl tte jq alacritty; do
  if ! command -v "$cmd" &>/dev/null; then
    MISSING+=("$cmd")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo -e "${RED}❌ Missing commands: ${MISSING[*]}${NC}"
  echo "Install with: sudo pacman -S python-terminaltexteffects jq alacritty"
  exit 1
fi

echo -e "${GREEN}✅ All dependencies found${NC}"
echo

# Create directories
echo "📂 Creating directories..."
mkdir -p "$LOCAL_BIN"
mkdir -p "$SCREENSAVER_CONFIG"
echo -e "${GREEN}✅ Directories created${NC}"
echo

# Create screensaver command script
echo "📝 Creating screensaver command script..."

cat > "$LOCAL_BIN/screensaver-cmd" << 'EOFCMD'
#!/bin/bash

screensaver_in_focus() {
  hyprctl activewindow -j | jq -e '.class == "org.omarchy.screensaver"' >/dev/null 2>&1
}

exit_screensaver() {
  hyprctl keyword cursor:invisible false &>/dev/null || true
  pkill -x tte 2>/dev/null || true
  pkill -f org.omarchy.screensaver 2>/dev/null || true
  exit 0
}

# Exit the screensaver on signals and input from keyboard and mouse
trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

printf '\033]11;rgb:00/00/00\007'  # Set background color to black

hyprctl keyword cursor:invisible true &>/dev/null

tty=$(tty 2>/dev/null)

while true; do
  tte -i ~/.config/screensaver/art.txt \
    --frame-rate 120 --canvas-width 0 --canvas-height 0 --reuse-canvas --anchor-canvas c --anchor-text c\
    --random-effect --exclude-effects dev_worm \
    --no-eol --no-restore-cursor &

  while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
    if read -n1 -t 1 || ! screensaver_in_focus; then
      exit_screensaver
    fi
  done
done
EOFCMD

chmod +x "$LOCAL_BIN/screensaver-cmd"
echo -e "${GREEN}✅ Created: $LOCAL_BIN/screensaver-cmd${NC}"
echo

# Create screensaver launcher script
echo "📝 Creating screensaver launcher script..."

cat > "$LOCAL_BIN/screensaver-launch" << 'EOFLAUNCH'
#!/bin/bash

SCREENSAVER_CMD="$HOME/.local/bin/screensaver-cmd"
WINDOW_CLASS="org.omarchy.screensaver"

# Check if TTE is installed
if ! command -v tte &>/dev/null; then
  notify-send "Screensaver Error" "TTE (Terminal Text Effects) not installed"
  exit 1
fi

# Check if screensaver is already running
if pgrep -f "$WINDOW_CLASS" >/dev/null; then
  exit 0
fi

# Check for disable toggle
if [[ -f "$HOME/.local/state/screensaver/disabled" ]] && [[ "$1" != "force" ]]; then
  exit 0
fi

# Get current focused monitor
focused=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused == true).name')

# Detect terminal emulator
terminal=$(xdg-terminal-exec --print-id 2>/dev/null || echo "Alacritty")

# Launch screensaver on each monitor
for monitor in $(hyprctl monitors -j 2>/dev/null | jq -r '.[] | .name'); do
  hyprctl dispatch focusmonitor "$monitor" 2>/dev/null
  
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
      hyprctl dispatch exec -- \
        alacritty --class="$WINDOW_CLASS" \
        -o colors.primary.background="0x000000" \
        -o font.size=18 \
        -e "$SCREENSAVER_CMD"
      ;;
  esac
  
  sleep 0.1
done

# Return focus to original monitor
if [ -n "$focused" ]; then
  hyprctl dispatch focusmonitor "$focused" 2>/dev/null
fi
EOFLAUNCH

chmod +x "$LOCAL_BIN/screensaver-launch"
echo -e "${GREEN}✅ Created: $LOCAL_BIN/screensaver-launch${NC}"
echo

# Create ASCII art
echo "🎨 Creating ASCII art file..."

cat > "$SCREENSAVER_CONFIG/art.txt" << 'EOFART'
██████████████████████████████████████████████████████
██████████████████████████████████████████████████████
████                     ████                     ████
████                     ████                     ████
████    █████████████████████         ████████    ████
████    █████████████████████         ████████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████████████                              ████    ████
████████████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ████                              ████    ████
████    ██████████████████████████████████████    ████
████    ██████████████████████████████████████    ████
████                     ████                     ████
████                     ████                     ████
█████████████████████████████     ████████████████████
█████████████████████████████     ████████████████████
EOFART

echo -e "${GREEN}✅ Created: $SCREENSAVER_CONFIG/art.txt${NC}"
echo

# Check hypridle config
echo "🔍 Checking hypridle configuration..."

if [ ! -f "$CONFIG_DIR/hypridle.conf" ]; then
  echo -e "${RED}❌ hypridle.conf not found${NC}"
  exit 1
fi

if grep -q "screensaver-launch" "$CONFIG_DIR/hypridle.conf"; then
  echo -e "${YELLOW}⚠️  Screensaver listener already in hypridle.conf${NC}"
else
  echo "📝 Adding screensaver listener to hypridle.conf..."
  
  cp "$CONFIG_DIR/hypridle.conf" "$CONFIG_DIR/hypridle.conf.backup.$(date +%s)"
  echo -e "${GREEN}✅ Backup created${NC}"
  
  cat >> "$CONFIG_DIR/hypridle.conf" << 'EOF'

# OMARCHY SCREENSAVER LISTENER (150 seconds / 2.5 minutes)
listener {
    timeout = 150
    on-timeout = pidof hyprlock || ~/.local/bin/screensaver-launch
}
EOF
  echo -e "${GREEN}✅ Listener added${NC}"
fi

echo

# Check window rules
echo "🔍 Checking window rules configuration..."

WINDOW_RULES_FILE="$CONFIG_DIR/UserConfigs/WindowRules.conf"

if grep -q "org.omarchy.screensaver" "$WINDOW_RULES_FILE"; then
  echo -e "${YELLOW}⚠️  Window rule already exists${NC}"
else
  echo "📝 Adding window rules..."
  
  cp "$WINDOW_RULES_FILE" "$WINDOW_RULES_FILE.backup.$(date +%s)"
  echo -e "${GREEN}✅ Backup created${NC}"
  
  cat >> "$WINDOW_RULES_FILE" << 'EOF'

# OMARCHY SCREENSAVER WINDOW RULES
windowrule {
  name = windowrule-omarchy-screensaver
  fullscreen = on
  float = on
  match:class = ^(org.omarchy.screensaver)$
}
EOF
  echo -e "${GREEN}✅ Rules added${NC}"
fi

echo

# Installation summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              INSTALLATION SUMMARY                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

echo "✅ Omarchy screensaver is configured!"
echo

echo "📋 What was done:"
echo "  1. ✓ Created screensaver command: $LOCAL_BIN/screensaver-cmd"
echo "  2. ✓ Created launcher script: $LOCAL_BIN/screensaver-launch"
echo "  3. ✓ Created ASCII art: $SCREENSAVER_CONFIG/art.txt"
echo "  4. ✓ Added hypridle listener"
echo "  5. ✓ Added window rules"
echo

echo "🚀 Next steps:"
echo "  1. Reload Hyprland: Super+Shift+R (or restart)"
echo "  2. Restart hypridle:"
echo "     pkill hypridle"
echo "     hypridle &"
echo "  3. Wait 2.5 minutes without activity to trigger"
echo "  4. Or test manually:"
echo "     ~/.local/bin/screensaver-launch"
echo

echo "🎨 Customization:"
echo "  • Change ASCII art: Edit $SCREENSAVER_CONFIG/art.txt"
echo "  • Change effect: Edit screensaver-cmd and replace --random-effect"
echo "  • Change timeout: Edit hypridle.conf listener timeout"
echo "  • Disable: mkdir -p ~/.local/state/screensaver && touch ~/.local/state/screensaver/disabled"
echo

echo -e "${GREEN}✨ Setup complete! Enjoy your screensaver! ✨${NC}"
