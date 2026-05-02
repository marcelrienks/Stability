#!/bin/bash

# Skill deployment script with platform detection
# Usage: ./deploy-skills.sh [agents|copilot|claude]

set -e

# Detect platform
detect_platform() {
  if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "wsl"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    echo "win"
  else
    echo "linux"
  fi
}

# Get platform-specific paths
get_platform_paths() {
  local platform="$1"
  
  case "$platform" in
    macos)
      AGENTS_DIR="${HOME}/.agents/skills"
      COPILOT_DIR="${HOME}/.copilot/skills"
      CLAUDE_DIR="${HOME}/.claude/skills"
      ;;
    wsl)
      AGENTS_DIR="${HOME}/.agents/skills"
      COPILOT_DIR="${HOME}/.copilot/skills"
      CLAUDE_DIR="${HOME}/.claude/skills"
      ;;
    win)
      AGENTS_DIR="${APPDATA}\.agents\skills"
      COPILOT_DIR="${APPDATA}\.copilot\skills"
      CLAUDE_DIR="${APPDATA}\.claude\skills"
      ;;
    linux)
      AGENTS_DIR="${HOME}/.agents/skills"
      COPILOT_DIR="${HOME}/.copilot/skills"
      CLAUDE_DIR="${HOME}/.claude/skills"
      ;;
  esac
}

# Main script
PLATFORM=$(detect_platform)
get_platform_paths "$PLATFORM"

# Get target from argument
TARGET="${1:-agents}"

# Determine target directory
case "$TARGET" in
  agents)
    TARGET_DIR="$AGENTS_DIR"
    ;;
  copilot)
    TARGET_DIR="$COPILOT_DIR"
    ;;
  claude)
    TARGET_DIR="$CLAUDE_DIR"
    ;;
  *)
    echo "Invalid target: $TARGET"
    echo "Usage: $0 [agents|copilot|claude]"
    exit 1
    ;;
esac

echo "Platform: $PLATFORM"
echo "Deploying skills to: $TARGET_DIR"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Delete all existing skills with 'cel.' prefix
echo "Removing existing cel.* skills..."
find "$TARGET_DIR" -maxdepth 1 -type d -name "cel.*" -exec rm -rf {} + 2>/dev/null || true

# Copy all skill directories from current project
echo "Copying skills from project..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE_DIR="$SCRIPT_DIR"

if [ ! -d "$SKILLS_SOURCE_DIR" ]; then
  echo "Error: Skills directory not found at $SKILLS_SOURCE_DIR"
  exit 1
fi

for skill_dir in "$SKILLS_SOURCE_DIR"/*/; do
  if [ -d "$skill_dir" ]; then
    skill_name=$(basename "$skill_dir")
    echo "  → Copying $skill_name"
    cp -r "${skill_dir%/}" "$TARGET_DIR/"
  fi
done

echo "✓ Deployment complete!"
echo "Target: $TARGET ($TARGET_DIR)"
echo "Skills deployed: $(ls -1d $TARGET_DIR/cel.* 2>/dev/null | wc -l)"
