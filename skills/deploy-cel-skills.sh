#!/bin/bash

# Skill deployment script - auto-detects environment and deploys accordingly
# On WSL: deploys to both WSL and Windows environments

set -e

# Display help message
show_help() {
  cat << 'EOF'
Skill Deployment Script

Deploy CEL skills to specified agent platforms.

USAGE:
  ./deploy-cel-skills.sh [--agent AGENT] [--help]

OPTIONS:
  --agent AGENT    Target agent platform (default: agents)
                   Valid values: agents, copilot, claude

                   agents:  Deploy to ~/.agents/skills/
                   copilot: Deploy to ~/.copilot/skills/
                   claude:  Deploy to Claude Code (~/.claude/commands/) and
                            Claude Desktop (platform-specific) as flat .md files

  -h, --help       Show this help message and exit

EXAMPLES:
  # Deploy to agents (default)
  ./deploy-cel-skills.sh

  # Deploy to Copilot
  ./deploy-cel-skills.sh --agent copilot

  # Deploy to Claude Code and Claude Desktop (flat .md files)
  ./deploy-cel-skills.sh --agent claude

BEHAVIOR:
  - Auto-detects platform (macOS, Linux, WSL)
  - On WSL: deploys to both WSL and Windows environments
  - Removes existing cel.* skills before deploying new ones
  - Creates target directories if they don't exist
EOF
}


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
      CLAUDE_CODE_DIR="${HOME}/.claude/commands"
      CLAUDE_DESKTOP_DIR="${HOME}/Library/Application Support/Claude/commands"
      ;;
    wsl)
      AGENTS_DIR="${HOME}/.agents/skills"
      COPILOT_DIR="${HOME}/.copilot/skills"
      CLAUDE_DIR="${HOME}/.claude/skills"
      CLAUDE_CODE_DIR="${HOME}/.claude/commands"
      CLAUDE_DESKTOP_DIR=""  # Claude Desktop runs on Windows, not WSL
      ;;
    linux)
      AGENTS_DIR="${HOME}/.agents/skills"
      COPILOT_DIR="${HOME}/.copilot/skills"
      CLAUDE_DIR="${HOME}/.claude/skills"
      CLAUDE_CODE_DIR="${HOME}/.claude/commands"
      CLAUDE_DESKTOP_DIR="${HOME}/.config/Claude/commands"
      ;;
  esac
}

# Deploy skills as directories to a target directory (agents, copilot, legacy claude)
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

# Deploy skills as flat .md files to Claude Code/Desktop commands directory
deploy_claude_commands_to() {
  local target_name="$1"
  local target_dir="$2"

  echo "Deploying Claude commands to $target_name: $target_dir"

  # Create target directory if it doesn't exist
  mkdir -p "$target_dir"

  # Delete all existing commands with 'cel.' prefix
  echo "  → Removing existing cel.*.md commands..."
  find "$target_dir" -maxdepth 1 -type f -name "cel.*.md" -delete 2>/dev/null || true

  # Copy each skill's SKILL.md as <skill-name>.md
  echo "  → Copying skills from project as commands..."
  local deployed_count=0
  for skill_dir in "$SKILLS_SOURCE_DIR"/*/; do
    if [ -d "$skill_dir" ] && [ -f "${skill_dir}SKILL.md" ]; then
      skill_name=$(basename "$skill_dir")
      echo "    → Copying $skill_name"
      cp "${skill_dir}SKILL.md" "$target_dir/${skill_name}.md"
      ((deployed_count++))
    fi
  done

  echo "  ✓ $deployed_count commands deployed"
}

# Main script
PLATFORM=$(detect_platform)
get_platform_paths "$PLATFORM"

# Parse arguments
TARGET="agents"  # Default target

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    --agent)
      if [ -z "$2" ] || [[ "$2" == --* ]]; then
        echo "Error: --agent requires a value (agents, copilot, or claude)"
        echo "Use --help for usage information"
        exit 1
      fi
      TARGET="$2"
      shift 2
      ;;
    *)
      echo "Error: Unknown argument: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Validate target
case "$TARGET" in
  agents|copilot|claude)
    ;;
  *)
    echo "Error: Invalid target: $TARGET"
    echo "Valid targets: agents, copilot, claude"
    echo "Use --help for usage information"
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
echo "Target agent: $TARGET"
echo ""

# Handle claude target: deploy to Claude Code and Claude Desktop
if [ "$TARGET" = "claude" ]; then
  # Deploy to Claude Code (all platforms)
  deploy_claude_commands_to "Claude Code ($PLATFORM)" "$CLAUDE_CODE_DIR"

  # Deploy to Claude Desktop (platform-specific)
  if [ -n "$CLAUDE_DESKTOP_DIR" ]; then
    echo ""
    deploy_claude_commands_to "Claude Desktop ($PLATFORM)" "$CLAUDE_DESKTOP_DIR"
  fi

  # If WSL, also deploy to Windows environment
  if [ "$PLATFORM" = "wsl" ]; then
    echo ""
    echo "WSL detected - also deploying to Windows environment..."
    WIN_USER_ROOT="/mnt/c/Users/admin"
    WIN_CLAUDE_CODE_DIR="$WIN_USER_ROOT/.claude/commands"
    WIN_CLAUDE_DESKTOP_DIR="$WIN_USER_ROOT/AppData/Roaming/Claude/commands"

    echo ""
    deploy_claude_commands_to "Claude Code (Windows)" "$WIN_CLAUDE_CODE_DIR"
    deploy_claude_commands_to "Claude Desktop (Windows)" "$WIN_CLAUDE_DESKTOP_DIR"
  fi

# Handle agents and copilot targets: deploy as directories
else
  # Determine target directory for current platform
  case "$TARGET" in
    agents)
      TARGET_DIR="$AGENTS_DIR"
      ;;
    copilot)
      TARGET_DIR="$COPILOT_DIR"
      ;;
  esac

  # Safety check: prevent deploying to the source directory
  if [ "$TARGET_DIR" = "$SKILLS_SOURCE_DIR" ]; then
    echo "Error: Cannot deploy to the source directory itself ($SKILLS_SOURCE_DIR)"
    exit 1
  fi

  # Prevent deploying to a parent directory of the source
  if [[ "$SKILLS_SOURCE_DIR" == "$TARGET_DIR"* ]]; then
    echo "Error: Target directory ($TARGET_DIR) conflicts with source location ($SKILLS_SOURCE_DIR)"
    exit 1
  fi

  # Deploy to current platform
  deploy_to "$PLATFORM" "$TARGET_DIR"

  # If WSL, also deploy to Windows
  if [ "$PLATFORM" = "wsl" ]; then
    echo ""
    echo "WSL detected - also deploying to Windows environment..."

    # Windows user root path from WSL
    WIN_USER_ROOT="/mnt/c/Users/admin"
    WIN_AGENTS_DIR="$WIN_USER_ROOT/.agents/skills"
    WIN_COPILOT_DIR="$WIN_USER_ROOT/.copilot/skills"

    # Determine Windows target directory based on argument
    case "$TARGET" in
      agents)
        WIN_TARGET_DIR="$WIN_AGENTS_DIR"
        ;;
      copilot)
        WIN_TARGET_DIR="$WIN_COPILOT_DIR"
        ;;
    esac

    deploy_to "win" "$WIN_TARGET_DIR"
  fi
fi

echo ""
echo "✓ Deployment complete!"
