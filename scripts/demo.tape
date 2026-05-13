# demo.tape — vhs tape for qa-persona demo GIF
#
# Maintainer: run `vhs scripts/demo.tape` to regenerate docs/demo.gif.
# Requires: vhs (https://github.com/charmbracelet/vhs), claude CLI with qa-persona plugin installed.
# Target: 30–60 s showing install, /qa-persona:init, value-loop summary, persona table.
#
# Tested against: listmonk (https://github.com/knadh/listmonk) — the codebase
# from the 2026-05-12 dogfood run (issue #1).

Output docs/demo.gif

Set Shell "bash"
Set FontSize 14
Set Width 1200
Set Height 700
Set Theme "Catppuccin Mocha"
Set TypingSpeed 40ms
Set Padding 20

# --- Title card ---
Type "# qa-persona — persona-driven E2E testing for multi-actor SaaS"
Sleep 1.5s
Ctrl+C

# --- Show plugin is installed ---
Type "claude --version"
Enter
Sleep 1s

Type "# Plugin installed at ~/.claude/plugins/cache/local/qa-persona"
Sleep 1s
Ctrl+C

# --- Navigate to a cloned listmonk directory ---
Type "cd /tmp/listmonk-demo && ls"
Enter
Sleep 1.5s

# --- Launch qa-persona:init ---
Type "claude /qa-persona:init"
Enter
Sleep 3s

# --- Wait for value-loop summary to appear ---
# (vhs captures whatever the claude CLI outputs; timing may need adjustment)
Sleep 5s

# --- Scroll through value-loop summary ---
# The init skill prints the value-loop paragraph and asks for confirmation.
# We show the output for a few seconds so the viewer can read it.
Sleep 4s

# --- Persona table appears after confirmation ---
# In a real run the user types 'y' to confirm the value-loop summary.
Type "y"
Enter
Sleep 5s

# --- Persona table is now visible; hold for viewer ---
Sleep 4s

# --- End card ---
Type "# See examples/sample-project/ for full Phase 1-3 output"
Sleep 2s
Ctrl+C

Sleep 1s
