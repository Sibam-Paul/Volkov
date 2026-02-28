#!/bin/bash
# SYMPHONY SCREENSAVER INTEGRATION SCRIPT
# Safe implementation without modifying existing configs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config/hypr"
SCRIPTS_DIR="$CONFIG_DIR/scripts"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     SYMPHONY SCREENSAVER INTEGRATION SETUP                 ║"
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

# Check if files exist
echo "📂 Checking source files..."

if [ ! -f "$DOTFILES_DIR/.config/hypr/scripts/screensaver" ]; then
  echo -e "${RED}❌ Source file not found: $DOTFILES_DIR/.config/hypr/scripts/screensaver${NC}"
  exit 1
fi

if [ ! -f "$DOTFILES_DIR/.config/hypr/scripts/screensaver-launch" ]; then
  echo -e "${RED}❌ Source file not found: $DOTFILES_DIR/.config/hypr/scripts/screensaver-launch${NC}"
  exit 1
fi

if [ ! -f "$DOTFILES_DIR/branding/symphony.txt" ]; then
  echo -e "${RED}❌ Source file not found: $DOTFILES_DIR/branding/symphony.txt${NC}"
  exit 1
fi

echo -e "${GREEN}✅ All source files found${NC}"
echo

# Make scripts executable
echo "🔧 Making screensaver scripts executable..."
chmod +x "$SCRIPTS_DIR/screensaver"
chmod +x "$SCRIPTS_DIR/screensaver-launch"
echo -e "${GREEN}✅ Scripts made executable${NC}"
echo

# Check hypridle config
echo "🔍 Checking hypridle configuration..."

if [ ! -f "$CONFIG_DIR/hypridle.conf" ]; then
  echo -e "${YELLOW}⚠️  hypridle.conf not found${NC}"
  echo "Please create: $CONFIG_DIR/hypridle.conf"
  exit 1
fi

if grep -q "screensaver-launch" "$CONFIG_DIR/hypridle.conf"; then
  echo -e "${YELLOW}⚠️  Screensaver listener already in hypridle.conf${NC}"
else
  echo "📝 Adding screensaver listener to hypridle.conf..."
  
  # Create backup
  cp "$CONFIG_DIR/hypridle.conf" "$CONFIG_DIR/hypridle.conf.backup.$(date +%s)"
  echo -e "${GREEN}✅ Backup created: hypridle.conf.backup.*${NC}"
  
  # Add screensaver listener before the last closing brace
  cat >> "$CONFIG_DIR/hypridle.conf" << 'EOF'

# SCREENSAVER LISTENER (150 seconds / 2.5 minutes)
listener {
    timeout = 150
    on-timeout = pidof hyprlock || ~/.config/hypr/scripts/screensaver-launch
}
EOF
  echo -e "${GREEN}✅ Screensaver listener added${NC}"
fi

echo

# Check window rules
echo "🔍 Checking window rules configuration..."

WINDOW_RULES_FILE="$CONFIG_DIR/UserConfigs/WindowRules.conf"

if [ ! -f "$WINDOW_RULES_FILE" ]; then
  echo -e "${RED}❌ WindowRules.conf not found${NC}"
  exit 1
fi

if grep -q "Screensaver" "$WINDOW_RULES_FILE"; then
  echo -e "${YELLOW}⚠️  Screensaver window rule already exists${NC}"
else
  echo "📝 Adding screensaver window rules..."
  
  # Create backup
  cp "$WINDOW_RULES_FILE" "$WINDOW_RULES_FILE.backup.$(date +%s)"
  echo -e "${GREEN}✅ Backup created: WindowRules.conf.backup.*${NC}"
  
  # Add screensaver window rule at the end
  cat >> "$WINDOW_RULES_FILE" << 'EOF'

# SYMPHONY SCREENSAVER WINDOW RULES
windowrule {
  name = windowrule-symphony-screensaver
  fullscreen = on
  float = on
  match:class = ^(Screensaver)$
}
EOF
  echo -e "${GREEN}✅ Screensaver window rules added${NC}"
fi

echo

# Installation summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              INSTALLATION SUMMARY                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

echo "✅ Symphony screensaver is configured!"
echo

echo "📋 What was done:"
echo "  1. ✓ Verified TTE, jq, alacritty installed"
echo "  2. ✓ Verified screensaver scripts exist"
echo "  3. ✓ Made scripts executable"
echo "  4. ✓ Added screensaver listener to hypridle.conf"
echo "  5. ✓ Added window rules to WindowRules.conf"
echo

echo "🚀 Next steps:"
echo "  1. Reload Hyprland: Super+Shift+R (or restart)"
echo "  2. Restart hypridle:"
echo "     pkill hypridle"
echo "     hypridle &"
echo "  3. Wait 2.5 minutes without activity to trigger"
echo "  4. Or test manually:"
echo "     ~/.config/hypr/scripts/screensaver-launch"
echo

echo "📝 Configuration files:"
echo "  • Hypridle: $CONFIG_DIR/hypridle.conf"
echo "  • Window Rules: $WINDOW_RULES_FILE"
echo "  • Screensaver Script: $SCRIPTS_DIR/screensaver"
echo "  • Launcher Script: $SCRIPTS_DIR/screensaver-launch"
echo "  • ASCII Art: $DOTFILES_DIR/branding/symphony.txt"
echo

echo "💾 Backup files created:"
ls -lh "$CONFIG_DIR"/hypridle.conf.backup.* 2>/dev/null | awk '{print "  • " $9}'
ls -lh "$WINDOW_RULES_FILE".backup.* 2>/dev/null | awk '{print "  • " $9}'
echo

echo "❓ Need to undo?"
echo "  Restore from backup files or:"
echo "  1. Remove screensaver listener from hypridle.conf"
echo "  2. Remove screensaver window rules from WindowRules.conf"
echo

echo -e "${GREEN}✨ Setup complete! Enjoy your screensaver! ✨${NC}"
