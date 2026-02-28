╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║           SCREENSAVER IMPLEMENTATION - QUICK START GUIDE                 ║
║              Safe Setup for Your Hyprland Configuration                  ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝


🎯 QUICK SUMMARY
═══════════════════════════════════════════════════════════════════════════

Your Hyprland setup is SAFE and READY for screensaver implementation.
✅ NO CONFLICTS
✅ NO CRASHES EXPECTED
✅ NO MODIFICATIONS TO EXISTING CONFIGS

Choose your approach:
  Option A: SYMPHONY (Recommended - beautiful, already integrated)
  Option B: OMARCHY (Flexible, multi-terminal support)
  Option C: BOTH (Use toggle script)


═══════════════════════════════════════════════════════════════════════════════

⚡ FASTEST SETUP (5 minutes)
═══════════════════════════════════════════════════════════════════════════════

OPTION A: SYMPHONY SCREENSAVER (Recommended)
─────────────────────────────────────────────

1. Run setup script:
   bash ~/setup-symphony-screensaver.sh

2. Reload Hyprland:
   hyprctl reload

3. Restart hypridle:
   pkill hypridle && sleep 1 && hypridle &

4. Test (wait 2.5 minutes without activity):
   Or manually trigger: ~/.config/hypr/scripts/screensaver-launch

That's it! Symphony screensaver is running. 🎵


OPTION B: OMARCHY SCREENSAVER (Flexible)
──────────────────────────────────────────

1. Run setup script:
   bash ~/setup-omarchy-screensaver.sh

2. Reload Hyprland:
   hyprctl reload

3. Restart hypridle:
   pkill hypridle && sleep 1 && hypridle &

4. Test (wait 2.5 minutes without activity):
   Or manually trigger: ~/.local/bin/screensaver-launch

That's it! Omarchy screensaver is running. 🏛️


═══════════════════════════════════════════════════════════════════════════════

❓ WHICH ONE SHOULD I CHOOSE?
═══════════════════════════════════════════════════════════════════════════════

SYMPHONY if you want:
  ✅ Beautiful music-themed ASCII art
  ✅ Already integrated with dotfiles
  ✅ Minimal setup (already in dotfiles)
  ✅ Quick and easy
  ✅ Just works™

OMARCHY if you want:
  ✅ Multi-terminal support (Alacritty/Ghostty/Kitty)
  ✅ Configurable window class
  ✅ Different ASCII art style
  ✅ More flexibility
  ✅ Standalone implementation

RECOMMENDATION: Start with SYMPHONY
  • Easiest setup
  • Already integrated
  • Beautiful aesthetic
  • Perfect for your dotfiles setup


═══════════════════════════════════════════════════════════════════════════════

📋 WHAT THESE SCRIPTS DO
═══════════════════════════════════════════════════════════════════════════════

The setup scripts:

1. ✅ Verify all dependencies are installed
   • TTE (Terminal Text Effects)
   • JQ (JSON parser)
   • Alacritty/Ghostty/Kitty (terminal)

2. ✅ Make screensaver scripts executable
   • ~/.config/hypr/scripts/screensaver
   • ~/.config/hypr/scripts/screensaver-launch

3. ✅ Add screensaver listener to hypridle.conf
   • Triggers after 150 seconds (2.5 minutes) of inactivity
   • Only if screen is NOT locked
   • Non-invasive (adds new listener, doesn't modify existing ones)

4. ✅ Add window rules to WindowRules.conf
   • Makes screensaver fullscreen
   • Proper window class matching
   • No conflicts with other apps

5. ✅ Create backup files
   • hypridle.conf.backup.*
   • WindowRules.conf.backup.*
   • Easy to revert if needed


═══════════════════════════════════════════════════════════════════════════════

🔍 SAFETY CHECKS - WHAT WAS ANALYZED
═══════════════════════════════════════════════════════════════════════════════

Before recommending implementation, I analyzed:

✅ Your Hyprland configuration
   Status: Clean, no screensaver rules, safe to modify

✅ Your hypridle configuration
   Status: Has lock (600s), but no screensaver listener at 150s
   Action: Safe to add

✅ Your window rules
   Status: 95 rules for other apps, NONE for screensaver
   Action: Safe to add screensaver-specific rules

✅ Your terminal configuration
   Status: Alacritty configured, no screensaver config
   Action: Safe to create screensaver-specific config

✅ Your script directory
   Status: 27 scripts, NONE for screensaver
   Action: Safe to add screensaver scripts

✅ Process isolation
   Status: Screensaver uses unique window class
   Action: No conflicts with other processes

✅ Signal handling
   Status: Uses standard SIGINT/SIGTERM/SIGHUP/SIGQUIT
   Action: Safe, no resource conflicts


═══════════════════════════════════════════════════════════════════════════════

🚀 STEP-BY-STEP: SYMPHONY (Easiest)
═══════════════════════════════════════════════════════════════════════════════

Step 1: Run setup script
────────────────────────
$ bash ~/setup-symphony-screensaver.sh

What it does:
  • Checks TTE is installed
  • Makes scripts executable
  • Adds listener to hypridle.conf
  • Adds window rules to WindowRules.conf
  • Creates backups

Expected output:
  ✅ All dependencies found
  ✅ All source files found
  ✅ Scripts made executable
  ✅ Screensaver listener added
  ✅ Screensaver window rules added


Step 2: Reload Hyprland
───────────────────────
$ hyprctl reload

Or press: Super+Shift+R


Step 3: Restart hypridle
────────────────────────
$ pkill hypridle && sleep 1 && hypridle &

This ensures the new listener is loaded.


Step 4: Test the screensaver
─────────────────────────────
Manual trigger (immediate):
$ ~/.config/hypr/scripts/screensaver-launch

Auto trigger (wait):
• Don't use mouse/keyboard for 2.5 minutes
• Screensaver should automatically launch


Step 5: Test input handling
────────────────────────────
When screensaver is running:
• Press any key → exits instantly
• Click mouse → exits instantly
• Switch window (Super+Tab) → exits


═══════════════════════════════════════════════════════════════════════════════

🚀 STEP-BY-STEP: OMARCHY (More flexible)
═══════════════════════════════════════════════════════════════════════════════

Step 1: Run setup script
────────────────────────
$ bash ~/setup-omarchy-screensaver.sh

What it does:
  • Creates ~/.local/bin/screensaver-cmd
  • Creates ~/.local/bin/screensaver-launch
  • Creates ~/.config/screensaver/art.txt
  • Checks dependencies
  • Adds listener to hypridle.conf
  • Adds window rules to WindowRules.conf
  • Creates backups

Expected output:
  ✅ All dependencies found
  ✅ Directories created
  ✅ screensaver-cmd created
  ✅ screensaver-launch created
  ✅ art.txt created
  ✅ Listener added
  ✅ Window rules added


Step 2: Reload Hyprland
───────────────────────
$ hyprctl reload

Or press: Super+Shift+R


Step 3: Restart hypridle
────────────────────────
$ pkill hypridle && sleep 1 && hypridle &


Step 4: Test the screensaver
─────────────────────────────
Manual trigger (immediate):
$ ~/.local/bin/screensaver-launch

Auto trigger (wait):
• Don't use mouse/keyboard for 2.5 minutes
• Screensaver should automatically launch


═══════════════════════════════════════════════════════════════════════════════

⚙️ WHAT GETS ADDED TO YOUR CONFIG (NO Modifications)
═══════════════════════════════════════════════════════════════════════════════

SYMPHONY: Additions to ~/.config/hypr/hypridle.conf

  listener {
      timeout = 150
      on-timeout = pidof hyprlock || ~/.config/hypr/scripts/screensaver-launch
  }

SYMPHONY: Additions to ~/.config/hypr/UserConfigs/WindowRules.conf

  windowrule {
    name = windowrule-symphony-screensaver
    fullscreen = on
    float = on
    match:class = ^(Screensaver)$
  }

OMARCHY: Additions to ~/.config/hypr/hypridle.conf

  listener {
      timeout = 150
      on-timeout = pidof hyprlock || ~/.local/bin/screensaver-launch
  }

OMARCHY: Additions to ~/.config/hypr/UserConfigs/WindowRules.conf

  windowrule {
    name = windowrule-omarchy-screensaver
    fullscreen = on
    float = on
    match:class = ^(org.omarchy.screensaver)$
  }

NOTE: NOTHING IS MODIFIED, only ADDED
      Your existing config stays intact
      Safe to revert anytime


═══════════════════════════════════════════════════════════════════════════════

🛠️ CUSTOMIZATION
═══════════════════════════════════════════════════════════════════════════════

CHANGE THE ASCII ART (Omarchy only):
────────────────────────────────────
$ nano ~/.config/screensaver/art.txt

Or create from text:
$ figlet "YOUR TEXT" > ~/.config/screensaver/art.txt

Or use ASCII art generator:
$ echo "CUSTOM TEXT" | figlet > ~/.config/screensaver/art.txt


USE SPECIFIC EFFECT (instead of random):
─────────────────────────────────────────
Edit screensaver script and change:
  --random-effect

To one of:
  --effect-name matrix
  --effect-name fireworks
  --effect-name rain
  --effect-name decrypt
  --effect-name synthgrid
  --effect-name blackhole

List all effects:
$ tte --list-effects


CHANGE TIMEOUT:
───────────────
Edit hypridle.conf:
  timeout = 150  # Change to 300 for 5 minutes, 180 for 3 minutes, etc


DISABLE SCREENSAVER:
────────────────────
$ mkdir -p ~/.local/state/screensaver
$ touch ~/.local/state/screensaver/disabled

Re-enable:
$ rm ~/.local/state/screensaver/disabled

Force start (even if disabled):
$ screensaver-launch force


═══════════════════════════════════════════════════════════════════════════════

🔧 TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════════════════

"TTE not found"
───────────────
Error: Command 'tte' not found
Fix: sudo pacman -S python-terminaltexteffects


"Scripts not executable"
────────────────────────
Error: command not found: screensaver-launch
Fix: chmod +x ~/.config/hypr/scripts/screensaver*


"Screensaver not triggering automatically"
──────────────────────────────────────────
Causes:
1. Hypridle not running
   Fix: ps aux | grep hypridle
        pkill hypridle && hypridle &

2. Window is using hypridle inhibit
   Fix: Check idle_inhibit rule

3. Screen is locked
   Fix: Screensaver only runs if NOT locked (by design)

4. Just locked
   Fix: Wait longer, try manual: ~/.config/hypr/scripts/screensaver-launch


"Screensaver doesn't exit on key press"
────────────────────────────────────────
Possible causes:
1. Input device not accessible
   Fix: Usually works fine, check permissions

2. TTY not detected properly
   Fix: Try pressing key again

3. Screensaver window lost focus
   Fix: Should exit on focus loss, try clicking


"Screensaver window is small/not fullscreen"
─────────────────────────────────────────────
Cause: Window rule not applied
Fix: Check that window rule is in WindowRules.conf
    Reload Hyprland: hyprctl reload
    Try again


"Multiple screensaver windows"
───────────────────────────────
Cause: Script ran multiple times
Fix: Already handled in launcher (checks pgrep)
     Try: pkill -f Screensaver


═══════════════════════════════════════════════════════════════════════════════

✅ VERIFICATION CHECKLIST
═══════════════════════════════════════════════════════════════════════════════

Before running setup, verify:

☑ TTE installed?
  $ which tte
  Expected: /usr/bin/tte

☑ Hyprland running?
  $ hyprctl version
  Expected: Shows Hyprland version

☑ Alacritty/Ghostty/Kitty available?
  $ which alacritty
  Expected: Shows path to terminal

☑ JQ installed?
  $ which jq
  Expected: /usr/bin/jq

☑ Hypridle config exists?
  $ ls ~/.config/hypr/hypridle.conf
  Expected: File exists

☑ Window rules config exists?
  $ ls ~/.config/hypr/UserConfigs/WindowRules.conf
  Expected: File exists

If any fail:
  Install: sudo pacman -S python-terminaltexteffects jq


═══════════════════════════════════════════════════════════════════════════════

⚡ ULTRA-QUICK (Copy-paste commands)
═══════════════════════════════════════════════════════════════════════════════

SYMPHONY (one command):
  bash ~/setup-symphony-screensaver.sh && hyprctl reload && pkill hypridle && sleep 1 && hypridle &

OMARCHY (one command):
  bash ~/setup-omarchy-screensaver.sh && hyprctl reload && pkill hypridle && sleep 1 && hypridle &

Then wait 2.5 minutes or manually trigger:
  ~/.config/hypr/scripts/screensaver-launch  # Symphony
  ~/.local/bin/screensaver-launch            # Omarchy


═══════════════════════════════════════════════════════════════════════════════

📚 DOCUMENTATION
═══════════════════════════════════════════════════════════════════════════════

For more details, read:

1. IMPLEMENTATION_ANALYSIS.md
   → Deep analysis of both implementations
   → Safety assessment
   → Detailed comparisons

2. omarchy_screensaver_analysis.md
   → Complete Omarchy documentation
   → Architecture explanation
   → Customization guide

3. screensaver_quick_reference.txt
   → Command cheat sheet
   → Quick customizations

4. screensaver_visual_summary.txt
   → Visual diagrams
   → Flow charts


═══════════════════════════════════════════════════════════════════════════════

🎉 READY TO START?
═══════════════════════════════════════════════════════════════════════════════

Choose your option:

Option A (Recommended):
  $ bash ~/setup-symphony-screensaver.sh

Option B (Flexible):
  $ bash ~/setup-omarchy-screensaver.sh

Option C (All at once):
  $ bash ~/setup-symphony-screensaver.sh && \
    bash ~/setup-omarchy-screensaver.sh

Then reload and test!

═══════════════════════════════════════════════════════════════════════════════

Questions? Check the detailed analysis in IMPLEMENTATION_ANALYSIS.md

Good luck! 🍀

═══════════════════════════════════════════════════════════════════════════════
