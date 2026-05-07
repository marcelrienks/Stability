#!/bin/bash

# Skill deployment script - auto-detects environment and deploys accordingly
# On WSL: deploys to both WSL and Windows environments
# Usage: ./deploy-skills.sh [agents|copilot|claude]

set -e

# Detect platform (bash scripts can only run on macos, linux, or wsl)
detect_platform() {
  if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "wsl"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
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
    linux)
      AGENTS_DIR="${HOME}/.agents/skills"
      COPILOT_DIR="${HOME}/.copilot/skills"
      CLAUDE_DIR="${HOME}/.claude/skills"
      ;;
  esac
}

# Deploy skills to a target directory
deploy_to() {
  local target_name="$1"
  local target_dir="$2"
  
  echo "Deploying to $target_name: $target_dir"
  
  # Create target directory if it doesn't exist
  mkdir -p "$target_dir"
  
  # Delete all existing skills with 'cel.' prefix
  echo "  → Removing existing cel.* skills..."
  find "$target_dir" -maxdepth 1 -type d -name "cel.*" -exec rm -rf {} + 2>/dev/null || true
  
  # Copy all skill directories from current project
  echo "  → Copying skills from project..."
  for skill_dir in "$SKILLS_SOURCE_DIR"/*/; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      echo "    → Copying $skill_name"
      cp -r "${skill_dir%/}" "$target_dir/"
    fi
  done
  
  local count=$(ls -1d "$target_dir"/cel.* 2>/dev/null | wc -l)
  echo "  ✓ $count skills deployed"
}

# Main script
PLATFORM=$(detect_platform)
get_platform_paths "$PLATFORM"

# Get target from argument
TARGET="${1:-agents}"

# Determine target directory for current platform
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

# Get source directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE_DIR="$SCRIPT_DIR"

if [ ! -d "$SKILLS_SOURCE_DIR" ]; then
  echo "Error: Skills directory not found at $SKILLS_SOURCE_DIR"
  exit 1
fi

echo "Platform detected: $PLATFORM"
echo ""

# Deploy to current platform
deploy_to "$PLATFORM" "$TARGET_DIR"

# If WSL, also deploy to Windows
if [ "$PLATFORM" = "wsl" ]; then
  echo ""
  echo "WSL detected - also deploying to Windows environment..."
  
  # Windows user root path from WSL
  # Uses admin user path (can be customized if needed)
  WIN_USER_ROOT="/mnt/c/Users/admin"
  WIN_AGENTS_DIR="$WIN_USER_ROOT/.agents/skills"
  WIN_COPILOT_DIR="$WIN_USER_ROOT/.copilot/skills"
  WIN_CLAUDE_DIR="$WIN_USER_ROOT/.claude/skills"
  
  # Determine Windows target directory based on argument
  case "$TARGET" in
    agents)
      WIN_TARGET_DIR="$WIN_AGENTS_DIR"
      ;;
    copilot)
      WIN_TARGET_DIR="$WIN_COPILOT_DIR"
      ;;
    claude)
      WIN_TARGET_DIR="$WIN_CLAUDE_DIR"
      ;;
  esac
  
  deploy_to "win" "$WIN_TARGET_DIR"
fi

echo ""
echo "✓ Deployment complete!"
