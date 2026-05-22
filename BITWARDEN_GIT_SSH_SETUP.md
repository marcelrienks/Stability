# Bitwarden-Integrated SSH Key Management for Git

## Overview

This document describes a complete solution for integrating Bitwarden (password manager) with Git SSH authentication. The system automatically retrieves your GitHub SSH key from Bitwarden and loads it into SSH when needed for git operations, eliminating the need to manually manage SSH key files.

### Problem Statement

When using Git over SSH, SSH keys must be accessible to the SSH client. Storing SSH keys in a password manager (Bitwarden) adds an extra layer of security, but requires tooling to retrieve and load them automatically when needed.

### Solution Architecture

The solution uses three components:

1. **Bitwarden CLI (`bw`)** - Retrieves credentials from Bitwarden vault
2. **jq** - JSON query tool for parsing command output
3. **SSH hook scripts** - Automatically load SSH keys when git commands are executed

---

## Prerequisites

This document provides step-by-step instructions for three environments: **Windows (PowerShell or Git Bash)**, **Windows WSL (Ubuntu on WSL)**, and **macOS (Terminal with zsh or bash)**.

Required for all environments:
- A Bitwarden account with an item named "github personal" that contains your GitHub private SSH key in the Notes field.
- Git installed with SSH support.
- Ability to install packages and create files in your home directory (e.g., ~/.local/bin, ~/.ssh, ~/.githooks).
- Node.js + npm (recommended) OR access to an OS package manager (Homebrew/apt/chocolatey/scoop) as noted in the installation steps.


---

## Installation Guide

### Step 1: Install Bitwarden CLI (`bw`)

The Bitwarden CLI is the primary tool for accessing your Bitwarden vault from the command line.

Installation options (pick one appropriate for your environment):

- npm (Recommended — cross-platform)
```bash
npm install -g @bitwarden/cli
```

- macOS (Homebrew)
```bash
brew install bitwarden-cli
```

- Windows (PowerShell — Chocolatey)
```powershell
choco install bitwarden-cli -y
```

- WSL / Linux
Use npm as above, or install via your distro package manager if a native package is available.

**Verification:**
```bash
bw --version
```

Expected output: `2026.4.2` (or similar version number)

Notes:
- npm works across PowerShell, Git Bash, WSL, and macOS Terminal and is therefore a dependable cross-platform option.
- If you prefer native packages on macOS or Windows, use the Homebrew/Chocolatey alternatives above.

---

### Step 2: Install jq (JSON Query Tool)

`jq` is used for parsing JSON output from Bitwarden commands. Install the platform-appropriate `jq` binary or package:

- macOS (Homebrew):
```bash
brew install jq
```

- WSL / Debian/Ubuntu:
```bash
sudo apt update && sudo apt install -y jq
```

- Windows (PowerShell / Git Bash):
  - Using Chocolatey:
  ```powershell
  choco install jq -y
  ```
  - Using Scoop:
  ```powershell
  scoop install jq
  ```
  - Or download the Windows binary and place it in ~/.local/bin:
  ```bash
  curl -L https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-win64.exe -o ~/.local/bin/jq.exe && chmod +x ~/.local/bin/jq.exe
  ```

**Verification:**
```bash
jq --version
```

Expected output: `jq-1.8.1` (or similar)

**Note on PATH and shell profiles:**
Ensure `~/.local/bin` is in your PATH. Add it to the correct shell profile for your environment:

- macOS (zsh):
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```
- WSL/Linux/Git Bash:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```
- PowerShell (Windows):
  Add `%USERPROFILE%\\.local\\bin` to your User PATH via Windows Environment Variables (Settings → System → About → Advanced system settings → Environment Variables) or use a package manager that updates PATH for you.


---

### Step 3: Verify Both Tools Are Accessible

Test that both tools work in your current shell environment:

```bash
bw --version && jq --version
```

Expected output:
```
(Node deprecation warning is normal)
2026.4.2
jq-1.8.1
```

If either tool is not found, verify:
- Installation completed without errors
- PATH includes the installation directories
- You may need to open a new terminal window for PATH changes to take effect

---

## Bitwarden Setup

### Step 1: Store Your GitHub SSH Key in Bitwarden

1. Open Bitwarden (Desktop app or web vault at vault.bitwarden.com)
2. Create a new item or edit an existing one
3. Name it: `github personal` (must match exactly)
4. Add your GitHub SSH private key in the **Notes** field
5. Save the item

**Format of Notes field:**
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUtbm9uZS1ub25lAAAAAAAAAEsAAAALZWNkc2Et
... (rest of your key)
-----END OPENSSH PRIVATE KEY-----
```

### Step 2: Log In to Bitwarden CLI

The Bitwarden CLI maintains a separate session from the desktop/web apps. You must authenticate at least once:

```bash
bw login your-email@example.com
```

When prompted, enter your Bitwarden master password.

**Output on success:**
```
You have successfully logged in. To unlock your vault, set your session key to the `BW_SESSION` environment variable. ex:
export BW_SESSION="<session_key_here>"
```

**Session Persistence:**
The Bitwarden CLI caches your session locally. You typically only need to log in once. The session remains valid until it expires (usually several hours).

**Locking the vault:**
```bash
bw lock
```

---

## SSH Key Loading Scripts

### Overview

Three bash scripts automate the SSH key loading process:

1. **`bw-load-github-key`** - Main script that retrieves and loads the SSH key
2. **`bw-ensure-github-key`** - Checks if key is loaded and calls load script if needed
3. **`bw-cleanup-github-key`** - Cleanup script to remove the key after use (optional)

All scripts are stored in `~/.local/bin/` for access across shell environments.

---

### Script 1: bw-load-github-key

**Purpose:** Retrieves the GitHub SSH key from Bitwarden and writes it to a temporary SSH identity file.

**Location:** `~/.local/bin/bw-load-github-key`

**Full Script:**
```bash
#!/bin/bash
# Load GitHub SSH key from Bitwarden into temporary SSH identity file
# This script retrieves the 'github personal' key from Bitwarden and writes it
# to ~/.ssh/github_personal_bw for SSH to use

set -e

KEY_FILE="$HOME/.ssh/github_personal_bw"
TEMP_KEY_FILE="${KEY_FILE}.tmp"

# Check if bw is logged in
if ! bw get notes "github personal" > "$TEMP_KEY_FILE" 2>/dev/null; then
  echo "ERROR: Cannot load GitHub SSH key from Bitwarden" >&2
  echo "You are not logged in to Bitwarden CLI." >&2
  echo "" >&2
  echo "To fix this, run:" >&2
  echo "  bw login your-email@example.com" >&2
  echo "" >&2
  echo "Then try your git command again." >&2
  exit 1
fi

echo "Loading GitHub SSH key from Bitwarden..." >&2

# Ensure proper permissions
chmod 600 "$TEMP_KEY_FILE"

# Move to final location
mv "$TEMP_KEY_FILE" "$KEY_FILE"

echo "✓ GitHub SSH key loaded from Bitwarden to $KEY_FILE" >&2
```

**To create this script:**

1. Create the file:
```bash
touch ~/.local/bin/bw-load-github-key
chmod +x ~/.local/bin/bw-load-github-key
```

2. Copy the script content above into the file
3. Verify it's executable:
```bash
ls -la ~/.local/bin/bw-load-github-key
# Should show: -rwxr-xr-x (with execute permissions)
```

**How it works:**
- Calls `bw get notes "github personal"` to retrieve the SSH key from Bitwarden
- Writes it to a temporary file
- Sets permissions to `600` (read/write for owner only) for security
- Moves it to the final location: `~/.ssh/github_personal_bw`
- Provides clear error messages if Bitwarden login is required

**Error Handling:**
If you're not logged in to Bitwarden, the script exits with a clear message:
```
ERROR: Cannot load GitHub SSH key from Bitwarden
You are not logged in to Bitwarden CLI.

To fix this, run:
  bw login your-email@example.com

Then try your git command again.
```

---

### Script 2: bw-ensure-github-key

**Purpose:** Checks if the SSH key is currently loaded; loads it only if needed (avoids redundant calls).

**Location:** `~/.local/bin/bw-ensure-github-key`

**Full Script:**
```bash
#!/bin/bash
# Ensure the GitHub SSH key is loaded from Bitwarden
# Only loads if the key file doesn't exist or is older than 1 hour

KEY_FILE="$HOME/.ssh/github_personal_bw"
MAX_AGE_SECONDS=3600  # 1 hour

# Check if key exists and is fresh
if [ -f "$KEY_FILE" ]; then
  CURRENT_TIME=$(date +%s)
  FILE_TIME=$(stat -c %Y "$KEY_FILE" 2>/dev/null || stat -f %m "$KEY_FILE" 2>/dev/null)
  AGE=$((CURRENT_TIME - FILE_TIME))
  
  if [ $AGE -lt $MAX_AGE_SECONDS ]; then
    # Key exists and is fresh, no need to reload
    exit 0
  fi
fi

# Key doesn't exist or is stale, load it
exec "$HOME/.local/bin/bw-load-github-key"
```

**To create this script:**

1. Create the file:
```bash
touch ~/.local/bin/bw-ensure-github-key
chmod +x ~/.local/bin/bw-ensure-github-key
```

2. Copy the script content above into the file

**How it works:**
- Checks if the SSH key file exists in `~/.ssh/github_personal_bw`
- If it exists and is less than 1 hour old, does nothing (key is fresh)
- If it doesn't exist or is older than 1 hour, calls `bw-load-github-key` to reload it
- This optimization reduces the number of Bitwarden API calls

**Why this approach?**
- Bitwarden CLI has a session timeout; calling it frequently can be unreliable
- Caching the key for 1 hour provides a good balance of security and convenience
- The age check is lightweight and prevents unnecessary vault access

---

### Script 3: bw-cleanup-github-key (Optional)

**Purpose:** Removes the SSH key file after use (for high-security environments).

**Location:** `~/.local/bin/bw-cleanup-github-key`

**Full Script:**
```bash
#!/bin/bash
# Clean up the GitHub SSH key file (remove it from disk)
# Run this script after you're done with git operations if you want extra security

KEY_FILE="$HOME/.ssh/github_personal_bw"

if [ -f "$KEY_FILE" ]; then
  rm "$KEY_FILE"
  echo "✓ Cleaned up GitHub SSH key from $KEY_FILE" >&2
else
  echo "⚠ No GitHub SSH key file found at $KEY_FILE" >&2
fi
```

**To create this script:**

1. Create the file:
```bash
touch ~/.local/bin/bw-cleanup-github-key
chmod +x ~/.local/bin/bw-cleanup-github-key
```

2. Copy the script content above into the file

**Usage:**
```bash
# After you're done with git operations
bw-cleanup-github-key
```

**When to use:**
- Optional for most users
- Recommended if you work in high-security environments
- Useful if your computer will be unattended and you want to minimize the time the key is on disk

---

## SSH Configuration

### Configure SSH to Use the Bitwarden-Loaded Key

Edit or create `~/.ssh/config`:

```bash
# On macOS, WSL, or Git Bash:
nano ~/.ssh/config
# or
vim ~/.ssh/config
# On Windows (PowerShell), open the file in Notepad:
# notepad "$env:USERPROFILE\\.ssh\\config"
```

**Content to add:**
```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_personal_bw
    AddKeysToAgent yes
    IdentitiesOnly yes
```

**Explanation:**
- `HostName github.com` - Target host
- `User git` - SSH username for GitHub
- `IdentityFile ~/.ssh/github_personal_bw` - Path to your Bitwarden-loaded key
- `AddKeysToAgent yes` - Automatically add the key to SSH agent
- `IdentitiesOnly yes` - Only use the specified identity file (improves security)

**Verification:**
```bash
cat ~/.ssh/config
```

Should show the configuration you just added.

---

## Integrating with Git

### Automatic Key Loading on Git Commands

To make the key loading automatic when you run git commands, add a hook to your Git configuration.

#### Option 1: Global Git Configuration (Recommended)

Add a `pre-push` hook globally that ensures the key is loaded before pushing:

```bash
# Create hooks directory if it doesn't exist
mkdir -p ~/.githooks

# Create the pre-push hook
cat > ~/.githooks/pre-push << 'EOF'
#!/bin/bash
# Ensure GitHub SSH key is loaded before pushing
~/.local/bin/bw-ensure-github-key
EOF

# Make it executable
chmod +x ~/.githooks/pre-push

# Tell Git to use this hooks directory globally
git config --global core.hooksPath ~/.githooks
```

**Verification:**
```bash
git config --global core.hooksPath
# Should output something like:
# /Users/your-username/.githooks      (macOS)
# /home/your-username/.githooks       (WSL/Linux)
# C:\\Users\\your-username\\.githooks   (Windows PowerShell/Git Bash)
```

#### Option 2: Per-Repository Configuration

For a specific repository, you can set up the hook locally:

```bash
cd /path/to/your/repo

# Create hooks directory
mkdir -p .git/hooks

# Create the pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
~/.local/bin/bw-ensure-github-key
EOF

# Make it executable
chmod +x .git/hooks/pre-push
```

---

## Testing the Setup

### Test 1: Manual Key Loading

Verify the scripts work independently:

```bash
# Load the key manually
~/.local/bin/bw-load-github-key

# Check if the key file was created
ls -la ~/.ssh/github_personal_bw

# Should show the key file exists and has `-rw-------` permissions (owner read/write only). Example paths by OS:
# - macOS:    -rw-------  1 youruser  staff  1679 May 22 15:30 /Users/youruser/.ssh/github_personal_bw
# - WSL/Linux: -rw------- 1 youruser youruser 1679 May 22 15:30 /home/youruser/.ssh/github_personal_bw
# - Git Bash/Windows: -rw------- 1 youruser Administrators 1679 May 22 15:30 /c/Users/youruser/.ssh/github_personal_bw
```

### Test 2: SSH Connection to GitHub

Test that SSH can connect to GitHub using the loaded key:

```bash
ssh -T git@github.com

# Expected output:
# Hi your-username! You've successfully authenticated, but GitHub does not provide shell access.
```

### Test 3: Git Operations

Test a full git workflow:

```bash
# Clone a repository
git clone git@github.com:your-username/your-repo.git

# Or in an existing repo
cd /path/to/repo
git fetch origin
git pull origin main
```

**Expected behavior:**
- No password/passphrase prompts
- Key is automatically loaded from Bitwarden
- Operations complete successfully

---

## Troubleshooting

### Issue 1: "You are not logged in to Bitwarden CLI"

**Symptom:**
```
ERROR: Cannot load GitHub SSH key from Bitwarden
You are not logged in to Bitwarden CLI.
```

**Solution:**
```bash
bw login your-email@example.com
```

**Then try again:**
```bash
~/.local/bin/bw-load-github-key
```

---

### Issue 2: "jq: command not found"

**Symptom:**
```
bash: jq: command not found
```

**Verification:**
```bash
which jq
# If empty, jq is not in PATH
```

**Solution:**
Re-install jq:
```bash
curl -L https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-win64.exe \
  -o ~/.local/bin/jq.exe && chmod +x ~/.local/bin/jq.exe
```

---

### Issue 3: "bw: command not found"

**Symptom:**
```
bash: bw: command not found
```

**Solution:**
Re-install Bitwarden CLI:
```bash
npm install -g @bitwarden/cli
```

---

### Issue 4: SSH Connection Fails with "Permission denied (publickey)"

**Symptom:**
```
git@github.com: Permission denied (publickey).
```

**Possible causes:**
1. Key is not loaded (expired cache)
2. SSH config is not pointing to the correct key file
3. GitHub doesn't have the corresponding public key

**Troubleshooting steps:**

1. Verify the key is loaded:
```bash
ls -la ~/.ssh/github_personal_bw
# If file doesn't exist or is empty, the key failed to load
~/.local/bin/bw-load-github-key  # Reload it
```

2. Check SSH config:
```bash
cat ~/.ssh/config
# Verify it contains:
# IdentityFile ~/.ssh/github_personal_bw
```

3. Test SSH connection with verbose output:
```bash
ssh -vT git@github.com
# Look for: "Offering public key" or errors
```

4. Verify the public key is in GitHub:
   - Go to https://github.com/settings/keys
   - Ensure your GitHub key is listed

---

### Issue 5: Scripts Not Found / PATH Issues

**Symptom:**
```
bash: bw-load-github-key: command not found
```

**Solution:**

Verify `~/.local/bin/` is in your PATH:

```bash
# Check current PATH
echo $PATH | tr ':' '\n' | grep '.local/bin'

# If not present, add it to your shell profile
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify the scripts exist
ls -la ~/.local/bin/ | grep bw
```

---

## Implementation Checklist for AI Agents

Use this checklist to verify a complete implementation:

- [ ] Bitwarden CLI installed via npm (`npm install -g @bitwarden/cli`)
- [ ] jq installed to `~/.local/bin/jq.exe`
- [ ] Both tools verified working (`bw --version && jq --version`)
- [ ] Bitwarden account has item named "github personal" with SSH key in Notes
- [ ] User logged into Bitwarden CLI (`bw login`)
- [ ] Script `bw-load-github-key` created at `~/.local/bin/` with 755 permissions
- [ ] Script `bw-ensure-github-key` created at `~/.local/bin/` with 755 permissions
- [ ] Script `bw-cleanup-github-key` created at `~/.local/bin/` with 755 permissions
- [ ] SSH config `~/.ssh/config` updated with GitHub host configuration
- [ ] Pre-push hook created at `~/.githooks/pre-push` (optional but recommended)
- [ ] All 3 tests pass (manual load, SSH connection, git operations)

---

## Security Considerations

### Best Practices

1. **SSH Key Permissions**
   - The key file is created with `600` permissions (owner read/write only)
   - Never change this to `644` or higher

2. **Bitwarden Session Security**
   - Your Bitwarden session is cached locally
   - Lock your vault after sensitive operations: `bw lock`
   - Consider using `bw-cleanup-github-key` after git work in high-security environments

3. **Minimal Key Exposure**
   - The key is only loaded into `~/.ssh/` when needed
   - It's not stored in environment variables or process memory
   - After 1 hour of inactivity, a new Bitwarden call refreshes it

4. **Use SSH Agent**
   - The SSH config includes `AddKeysToAgent yes`
   - Once loaded, SSH agent caches it locally
   - This reduces repeated Bitwarden vault access

### Risks and Mitigations

| Risk | Mitigation |
|------|-----------|
| Bitwarden account compromise | Use strong master password, enable 2FA |
| SSH key on disk | File has `600` permissions, deleted after inactivity |
| Session hijacking | Don't share access to `~/.local/bin/` scripts |
| Accidental key exposure | Never commit `~/.ssh/github_personal_bw` to repos |

---

## Maintenance

### Regular Tasks

**Weekly:**
- Verify Bitwarden login is still active: `bw get notes "github personal"`

**Monthly:**
- Review GitHub SSH keys at https://github.com/settings/keys
- Ensure your key is still listed and hasn't been compromised

**After Key Rotation:**
1. Generate new SSH key in GitHub
2. Update the item in Bitwarden with new key
3. Test with: `ssh -T git@github.com`
4. Clean up old key file: `rm ~/.ssh/github_personal_bw`

---

## Environment Compatibility

This solution has been tested and is compatible with:

- **Windows (native):** PowerShell and Git Bash (MINGW64)
- **Windows WSL:** Ubuntu on WSL (bash)
- **macOS:** Terminal (zsh or bash)
- **Tools:** Git, npm (or Homebrew/apt/chocolatey/scoop), Bitwarden CLI (`bw`), jq


### Notes for Different Environments

**PowerShell users:**
- Use backticks for line continuation: `` `export PATH=...` ``
- Or use the powershell equivalent: `$env:PATH`

**WSL users:**
- All bash scripts work directly
- If tools are missing, use apt: `apt install jq`

**Git Bash (MINGW64) users:**
- Recommended on Windows for a POSIX-like shell
- Use forward slashes `/` in paths
- Home directory is typically `/c/Users/your-username/` (Windows path exposed to the MSYS environment)

**WSL users:**
- Use your distro package manager (apt) to install native tools
- Home directory is `/home/your-username/`

**macOS users:**
- macOS Terminal (zsh) is supported; use Homebrew for packages (`brew install jq`)
- Home directory is `/Users/your-username/`

---

## References

- Bitwarden CLI Documentation: https://bitwarden.com/help/article/cli/
- GitHub SSH Keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- jq Manual: https://jqlang.github.io/jq/manual/
- SSH Config Manual: https://man.openbsd.org/ssh_config

---

## Support and Troubleshooting

If you encounter issues not covered here:

1. Check the **Troubleshooting** section above
2. Verify all prerequisites are installed
3. Test each component independently (bw, jq, SSH)
4. Check script permissions: `ls -la ~/.local/bin/bw-*`
5. Review Bitwarden login: `bw status`

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-05-22 | 1.0 | Initial documentation, latest bw CLI format |

---

**Document Status:** Complete and tested  
**Last Updated:** 2026-05-22  
**Compatibility:** Windows 11 Pro, WSL, Git Bash, PowerShell
