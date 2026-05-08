# Setup and Installation

## System Requirements

- **Git**: Version control (for .git operations)
- **Bash**: Script execution environment (macOS, Linux, WSL)
- **Windows**: For running deploy-cel-skills.sh in WSL environment
- **Text Editor**: For editing skill files and documentation

### Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| **Windows (WSL)** | ✅ Supported | Primary development platform |
| **macOS** | ✅ Supported | Uses native bash |
| **Linux** | ✅ Supported | Uses native bash |
| **Windows (PowerShell)** | ⚠️ Limited | Use WSL for full functionality |

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/marcelrienks/stability.git
cd stability
```

### 2. Install Prerequisites

#### macOS
```bash
# Ensure Homebrew is installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git (if not already present)
brew install git
```

#### Linux/Debian-based
```bash
sudo apt-get update
sudo apt-get install -y git bash
```

#### WSL (Windows Subsystem for Linux)
```bash
# WSL comes with bash and git pre-installed
# If needed, ensure git is available:
git --version
```

### 3. Deploy Skills Locally

Navigate to the project directory and run the deployment script:

```bash
cd skills
./deploy-cel-skills.sh [agents|copilot|claude]
```

**Arguments:**
- `agents` (default) - Deploy to `~/.agents/skills`
- `copilot` - Deploy to `~/.copilot/skills` (GitHub Copilot)
- `claude` - Deploy to `~/.claude/skills` (Claude)

**On WSL:**
The script automatically deploys to both WSL and Windows environments:
```bash
./deploy-cel-skills.sh agents
# Deploys to:
# - WSL: ~/.agents/skills
# - Windows: /mnt/c/Users/admin/.agents/skills
```

### 4. Verify Installation

Check that skills are deployed:

```bash
# macOS/Linux
ls ~/.agents/skills/ | grep "cel\."

# WSL (check both environments)
ls ~/.agents/skills/ | grep "cel\."
ls /mnt/c/Users/admin/.agents/skills/ | grep "cel\."
```

You should see:
- `cel.git.sync`
- `cel.screen.read`
- `cel.src.review`
- `cel.wiki.init`
- `cel.wiki.read`
- `cel.wiki.simplify`
- `cel.wiki.write`

## Environment Configuration

### GitHub Copilot Integration

To use skills with GitHub Copilot in VS Code:

1. Install the GitHub Copilot extension
2. Deploy skills to copilot target:
   ```bash
   ./deploy-cel-skills.sh copilot
   ```
3. Skills will be available in Copilot chat

### Custom Agent Integration

To use skills with custom agents:

1. Deploy to desired target:
   ```bash
   ./deploy-cel-skills.sh [agents|copilot|claude]
   ```
2. Configure your agent to load skills from the deployment directory
3. Skills will be available in your agent environment

## Initial Workspace Setup

After installation, set up the documentation infrastructure:

```bash
# Initialize wiki structure
/cel.wiki.init

# Generate baseline documentation
/cel.wiki.write

# (Optional) Review documentation for quality
/cel.src.review
```

These commands create and populate the `wiki/` directory with comprehensive project documentation.

## Configuration Files

### opencode.json
Located at project root, contains:
- Model configuration (grok-code, gpt-5-nano)
- Permission settings (edit, bash, webfetch, write)
- Code formatter specifications

### .gitignore
Standard Git ignore patterns. Typically excludes:
- Build outputs and compiled files
- Dependency directories (node_modules, venv, etc.)
- IDE and editor artifacts
- OS-specific files

### claude.md
Behavioral guidelines for LLM-assisted development. Review this file to understand:
- Coding philosophy and best practices
- Change management principles
- Documentation standards

## Troubleshooting Installation

### Issue: Permission Denied on deploy-cel-skills.sh

```bash
# Add execute permission
chmod +x skills/deploy-cel-skills.sh

# Then run
./skills/deploy-cel-skills.sh
```

### Issue: Skills Not Found After Deployment

1. Verify deployment directory exists:
   ```bash
   ls -la ~/.agents/skills/
   ```

2. Check that CEL skills were copied:
   ```bash
   ls -la ~/.agents/skills/ | grep "cel\."
   ```

3. If empty, run deployment with verbose output:
   ```bash
   bash -x ./deploy-cel-skills.sh agents
   ```

### Issue: Wrong Platform Detected on WSL

The script auto-detects WSL by checking `/proc/version`. If misdetected:
1. Verify you're running bash (not PowerShell)
2. Manually check: `grep -i microsoft /proc/version`
3. Report issue with platform details

## Next Steps

1. **Explore Skills**: Review [skills.md](skills.md) for detailed skill descriptions
2. **Generate Docs**: Run `/cel.wiki.write` to create project documentation
3. **Review Code**: Use `/cel.src.review` to audit documentation quality
4. **Sync with Git**: Use `/cel.git.sync` to commit and push changes
5. **Read Development Guide**: See [development.md](development.md) for workflow details

## Maintenance

### Updating Skills

To update skills after pulling latest changes:

```bash
git pull origin main
./skills/deploy-cel-skills.sh agents
```

### Cleaning Up Old Deployments

The deployment script automatically removes old `cel.*` skills before installing new ones:

```bash
# Safe to run multiple times
./skills/deploy-cel-skills.sh agents
```

### Undeploying Skills

To remove all deployed CEL skills:

```bash
rm -rf ~/.agents/skills/cel.*
rm -rf ~/.copilot/skills/cel.*
rm -rf ~/.claude/skills/cel.*
```
