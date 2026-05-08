# Troubleshooting Guide

Common issues and solutions for the Stability project and its skills.

## Installation & Deployment

### Permission Denied on deploy-cel-skills.sh

**Problem**: 
```
./deploy-cel-skills.sh: Permission denied
```

**Solution**:
```bash
# Add execute permission to the script
chmod +x skills/deploy-cel-skills.sh

# Then run it
./skills/deploy-cel-skills.sh agents
```

**Explanation**: Script files need execute permission to run. This is required the first time you try to run the deployment script.

---

### Skills Not Found After Deployment

**Problem**: 
```
/cel.wiki.write not recognized
# or
No skills available in agent environment
```

**Solution**:

1. Verify deployment directory was populated:
   ```bash
   ls -la ~/.agents/skills/cel.*
   ```
   Should show directories like `cel.git.sync/`, `cel.wiki.write/`, etc.

2. If empty, run deployment again:
   ```bash
   ./deploy-cel-skills.sh agents
   ```

3. Check deployment script output for errors:
   ```bash
   bash -x ./deploy-cel-skills.sh agents
   # -x flag shows detailed execution trace
   ```

4. For GitHub Copilot, ensure you deployed to correct target:
   ```bash
   ./deploy-cel-skills.sh copilot
   ```

**Explanation**: Skills need to be deployed to the correct directory for your agent environment. Wrong target or failed deployment causes skills to not be available.

---

### Skills Deploy to Wrong Location

**Problem**: 
Skills deployed but not accessible in your agent.

**Solution**:

1. Identify correct deployment target:
   ```bash
   ./deploy-cel-skills.sh agents  # For custom agents
   ./deploy-cel-skills.sh copilot # For GitHub Copilot
   ./deploy-cel-skills.sh claude  # For Claude
   ```

2. Verify deployment directory:
   ```bash
   ls ~/.agents/skills/cel.git.sync/
   # Should show SKILL.md file
   ```

3. Confirm your agent reads from this location (check agent settings/documentation)

**Explanation**: Different agents read skills from different directories. You need to deploy to the correct target for your agent environment.

---

### WSL Deployment Not Reaching Windows

**Problem**: 
Skills deployed to WSL but not available in Windows agent.

**Solution**:

The script auto-detects WSL and should deploy to both environments. If this fails:

1. Verify WSL detection:
   ```bash
   grep -i microsoft /proc/version
   # Should show "Microsoft" or "microsoft"
   ```

2. If detection works, check Windows path:
   ```bash
   ls -la /mnt/c/Users/admin/.agents/skills/cel.*
   ```

3. If Windows path doesn't exist, manually copy:
   ```bash
   cp -r ~/.agents/skills/cel.* /mnt/c/Users/admin/.agents/skills/
   ```

**Explanation**: The deployment script detects WSL and copies skills to both WSL and Windows. If detection fails, you may need to manually copy files or adjust the script.

---

## Skill Usage

### /cel.git.sync Fails with Git Errors

**Problem**:
```
fatal: not a git repository
# or
Permission denied when trying to push
```

**Solution**:

1. Verify you're in a git repository:
   ```bash
   pwd
   # should be inside a git repo
   
   git status
   # if this works, you're in a repo
   ```

2. Check git configuration:
   ```bash
   git config user.name
   git config user.email
   # Both should be set
   ```

3. Verify push permissions:
   ```bash
   git remote -v
   # Should show origin with read+write
   ```

4. If credentials are needed:
   ```bash
   git push -v origin main
   # -v flag shows more details about what's happening
   ```

**Explanation**: Git sync requires valid git repository and push permissions. Authentication issues are most common.

---

### /cel.screen.read Not Finding Screenshots

**Problem**:
```
No screenshot found in default location
```

**Solution**:

1. Take a screenshot first:
   - **Windows**: Press `PrintScreen` or `Alt+PrintScreen`
   - **macOS**: Press `Cmd+Shift+5`
   - **Linux/WSL**: Use `gnome-screenshot` or screenshot tool

2. Verify screenshot was saved:
   ```bash
   # Windows/WSL
   ls -la /mnt/c/Users/admin/Pictures/Screenshots/
   
   # macOS
   ls -la ~/Desktop/
   
   # Linux
   ls -la ~/Pictures/Screenshots/
   ```

3. Ensure screenshot is recent (within last 2 minutes)

4. Skill will also check clipboard:
   ```bash
   # Windows: Screenshot should be in clipboard (Alt+PrtScn)
   # macOS: Screenshot goes to clipboard automatically
   ```

**Explanation**: The skill looks for recently modified screenshot files. If no file exists, it checks the clipboard. You need at least one recent screenshot.

---

### /cel.src.review Finds No Issues

**Problem**:
```
Documentation review shows no issues found
```

**Explanation**:
This is actually success! If no issues are found, your documentation is consistent and well-structured. You can verify by:

```bash
# Run review on specific phase
/cel.src.review fallacies     # Check for logical errors
/cel.src.review contradictions # Check for conflicts
/cel.src.review inconsistencies # Check for terminology
```

---

### /cel.wiki.init Doesn't Find My Documentation

**Problem**:
```
Wiki initialized but my markdown files weren't moved
```

**Solution**:

1. Check if files are in excluded directories:
   ```bash
   # Excluded directories include:
   # .git/, .github/, .vscode/, node_modules/, .venv/, vendor/
   # dist/, build/, archive/, backup/
   ```

2. If files are in excluded locations, manually copy them:
   ```bash
   cp docs/*.md wiki/
   cp README.md wiki/
   ```

3. Run wiki.init again:
   ```bash
   /cel.wiki.init
   ```

**Explanation**: The skill excludes certain directories (dependencies, build outputs, archives) to avoid copying generated or external documentation.

---

### /cel.wiki.read Shows Cache Miss Every Time

**Problem**:
```
"Project analyzed. Context persisted with hashes."
# Shows every time, never loads from cache
```

**Solution**:

1. Check if `.cel/context.md` was created:
   ```bash
   ls -la .cel/context.md
   ```

2. If missing, wiki/read should have created it. Check permissions:
   ```bash
   ls -la .cel/
   # Should show context.md
   ```

3. Verify .gitignore excludes .cel/:
   ```bash
   grep "\.cel" .gitignore
   # Should match
   ```

4. If .cel/context.md exists but not being used, check file hashes:
   ```bash
   head -20 .cel/context.md
   # Should show hashes and timestamps
   ```

**Explanation**: Cache file `.cel/context.md` should be created after first run. If it's not being created, check directory permissions and git configuration.

---

### /cel.wiki.write Takes Too Long

**Problem**:
```
Documentation generation seems to hang or is very slow
```

**Solution**:

1. Check if process is still running (use Ctrl+C to interrupt):
   ```bash
   # Process may take 30+ seconds on large projects
   # This is normal
   ```

2. If stuck, cancel and try with smaller scope:
   ```bash
   # Cancel current operation (Ctrl+C)
   
   # Try running component skills separately:
   /cel.wiki.init      # Initialize structure
   /cel.wiki.read      # Load context (should be faster)
   ```

3. Check available disk space:
   ```bash
   df -h .
   # Should have at least 1GB available
   ```

4. For very large projects, consider:
   ```bash
   # Use overwrite mode (slower but more thorough)
   /cel.wiki.write overwrite
   ```

**Explanation**: Documentation generation analyzes entire codebase, which takes time proportional to project size. This is normal for large projects.

---

## Git Workflow

### Merge Conflicts During /cel.git.sync

**Problem**:
```
git pull resulted in merge conflicts
```

**Solution**:

The skill should automatically handle most conflicts. If it can't:

1. Cancel the sync (Ctrl+C) if needed

2. Check conflict status:
   ```bash
   git status
   # Shows which files have conflicts
   ```

3. Resolve conflicts manually:
   ```bash
   # Edit conflicted files, removing conflict markers:
   # <<<<<<< HEAD
   # your changes
   # =======
   # remote changes
   # >>>>>>>
   
   # After editing, stage the file
   git add conflicted-file.md
   ```

4. Complete the merge:
   ```bash
   git commit -m "Resolve merge conflicts"
   ```

5. Push changes:
   ```bash
   git push origin main
   ```

**Explanation**: Merge conflicts occur when same lines are edited in both local and remote. The skill tries to auto-resolve but manual intervention may be needed.

---

## Documentation

### Wiki Files Not Generating

**Problem**:
```
/cel.wiki.write runs but doesn't create wiki/*.md files
```

**Solution**:

1. Verify wiki directory exists:
   ```bash
   ls -la wiki/
   # Should exist and be writable
   ```

2. If missing, initialize first:
   ```bash
   /cel.wiki.init
   ```

3. Check directory permissions:
   ```bash
   ls -ld wiki/
   # Should show rwx (readable, writable, executable)
   ```

4. Try again:
   ```bash
   /cel.wiki.write
   ```

**Explanation**: Wiki documentation files need the wiki/ directory to exist and be writable. Initialization creates this structure.

---

### Broken Links in Generated Documentation

**Problem**:
```
[reference](file.md) - file doesn't exist
```

**Solution**:

1. Generate documentation again:
   ```bash
   /cel.wiki.simplify force
   # This fixes cross-references
   ```

2. If links still broken, check file names:
   ```bash
   ls wiki/*.md
   # Verify all referenced files exist
   ```

3. Update broken links manually:
   ```bash
   # Find broken links
   grep -r "\[.*\](.*\.md)" wiki/
   
   # Fix them to match actual files
   ```

**Explanation**: Generated documentation should have correct links. If broken, files may have been renamed or reorganized.

---

## Platform-Specific Issues

### macOS: Script Permission Issues

**Problem**:
```
./deploy-cel-skills.sh: command not found
```

**Solution**:

1. Ensure you're running bash (not zsh):
   ```bash
   bash --version
   ```

2. Run script with bash explicitly:
   ```bash
   bash skills/deploy-cel-skills.sh agents
   ```

3. Or add shebang and permission:
   ```bash
   chmod +x skills/deploy-cel-skills.sh
   bash skills/deploy-cel-skills.sh agents
   ```

**Explanation**: macOS may default to zsh shell. Bash is required to run the deployment script.

---

### Linux: Path Not Found Errors

**Problem**:
```
/home/user/.agents/skills: No such file or directory
```

**Solution**:

1. Create required directories:
   ```bash
   mkdir -p ~/.agents/skills
   mkdir -p ~/.copilot/skills
   mkdir -p ~/.claude/skills
   ```

2. Then deploy:
   ```bash
   ./deploy-cel-skills.sh agents
   ```

**Explanation**: Linux systems don't automatically create hidden directories. You may need to create them first.

---

## Getting More Help

### Check Skill Documentation

Each skill includes detailed documentation:

```bash
cat skills/cel.wiki.write/SKILL.md
# View complete skill documentation
```

### Enable Verbose Debugging

Run commands with verbose output:

```bash
# Bash: use -x flag
bash -x skills/deploy-cel-skills.sh agents

# Git: use -v flag  
git -v push origin main

# General: enable debug mode
DEBUG=1 /cel.wiki.write
```

### Review Project Configuration

Check how the project is configured:

```bash
cat opencode.json        # Framework config
cat claude.md            # Behavioral guidelines
cat .gitignore           # Git exclusions
```

### Check Related Documentation

- [Setup](setup.md) - Installation and configuration
- [Development](development.md) - Development workflow
- [Skills](skills.md) - Detailed skill reference
- [Structure](structure.md) - Project organization
