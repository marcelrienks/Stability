# Skills Reference

Complete reference guide for all CEL (Coding Agent Skills) in the Stability project.

## Quick Reference Table

| Skill | Purpose | When to Use |
|-------|---------|------------|
| **cel.git.sync** | Automated git workflow | Sync local changes to remote |
| **cel.screen.read** | Screenshot analysis | Debug visual issues in terminal/editor |
| **cel.src.review** | Documentation audit | Check documentation for quality issues |
| **cel.wiki.init** | Wiki initialization | Set up wiki folder structure |
| **cel.wiki.read** | Context persistence | Load and cache project knowledge |
| **cel.wiki.simplify** | Wiki consolidation | Deduplicate and optimize docs |
| **cel.wiki.write** | Documentation generation | Create project documentation |

---

## cel.git.sync

**Purpose**: Automates the complete git workflow with intelligent commit messages and merge conflict resolution.

**Usage**:
```
/cel.git.sync
```

**What It Does**:

1. **Stages all changes** - `git add .`
2. **Generates intelligent commit message** - Analyzes diffs and creates meaningful summary
3. **Pulls from remote** - Fetches and merges latest changes
4. **Resolves merge conflicts** - Handles conflicts automatically (prefers remote when safe)
5. **Pushes to remote** - Uploads synchronized work

**When to Use**:
- After making changes to skills or documentation
- Need to sync with remote repository
- Want automatic conflict resolution
- Prefer one-command workflow instead of multiple git commands

**Example**:
```bash
# Make some changes to skill files
# ...

# Sync everything in one command
/cel.git.sync
# Output: All changes staged, committed, pulled, and pushed
```

**Important Notes**:
- Requires valid git repository
- Requires push permissions on remote
- Automatically resolves conflicts when possible
- Creates meaningful commit messages based on changes

---

## cel.screen.read

**Purpose**: Analyzes the latest screenshot to understand visual content and context within your current session.

**Usage**:
```
/cel.screen.read
```

**What It Does**:

1. **Detects your platform** - Windows, WSL, macOS, or Linux
2. **Locates latest screenshot** - From system screenshots directory
3. **Analyzes image content** - Examines visual elements in context
4. **Answers questions** - Provides detailed insights about what's shown

**When to Use**:
- Debugging visual issues in code editor or terminal
- Need AI analysis of error messages or stack traces
- Reviewing terminal output or UI state
- Want context about what's displayed on screen

**Platform Locations**:
| Platform | Directory |
|----------|-----------|
| Windows | `%USERPROFILE%\Pictures\Screenshots` |
| macOS | `~/Documents`, `~/Desktop` |
| Linux/WSL | `/mnt/c/Users/<username>/Pictures/Screenshots` or `~/Pictures/Screenshots` |

**Example Workflow**:
```bash
# Take a screenshot when you see an error
# (Alt+PrintScreen on Windows, etc.)

# Then ask the agent
/cel.screen.read
# Agent: "I found your latest screenshot..."

# Ask follow-up questions
"What error messages are visible?"
# Agent: "I can see XYZ error..."
```

**Important Notes**:
- Looks for images modified within last 2 minutes
- Falls back to clipboard if no recent file found
- Works with any image format (PNG, JPG, etc.)
- Analyzes in context of your current debugging task

---

## cel.src.review

**Purpose**: Performs comprehensive review of documentation for fallacies, contradictions, and inconsistencies.

**Usage**:
```
/cel.src.review               # Interactive review
/cel.src.review auto          # Auto-fix mode
/cel.src.review [phase] [mode] # Specific phase and mode
```

**What It Does**:

**Phase 1: Fallacy Analysis**
- Detects logical fallacies in documentation
- Finds unsupported claims and assumptions
- Identifies appeal to authority and false attributions

**Phase 2: Contradiction Analysis**
- Finds conflicting statements
- Detects feature mismatches
- Identifies scope conflicts

**Phase 3: Inconsistency Analysis**
- Finds naming inconsistencies
- Detects format variations
- Identifies terminology mismatches

**When to Use**:
- After writing or updating documentation
- Before committing documentation changes
- Need to ensure quality and consistency
- Want to identify documentation issues

**Usage Modes**:
```bash
# Full review, interactive (requires confirmation)
/cel.src.review

# Full review, auto-fix (implements solutions automatically)
/cel.src.review auto

# Specific phase only
/cel.src.review fallacies
/cel.src.review contradictions
/cel.src.review inconsistencies

# Specific phase, auto-fix
/cel.src.review contradictions auto
```

**Example**:
```bash
/cel.src.review
# Shows identified issues one by one
# Presents solutions for each issue
# Asks for confirmation before applying changes
```

**Important Notes**:
- Analyzes skill documentation and markdown files
- Interactive mode asks for confirmation
- Auto mode implements best solutions without asking
- Can be run on specific phases or all phases

---

## cel.wiki.init

**Purpose**: Initializes standardized wiki folder structure and consolidates documentation.

**Usage**:
```
/cel.wiki.init
```

**What It Does**:

1. **Creates folder structure** - `wiki/` and `wiki/raw/` directories
2. **Discovers markdown files** - Finds all `.md` files in project
3. **Moves markdown docs** - Consolidates to `wiki/` in flat structure
4. **Discovers static assets** - Finds PDFs, transcripts, images
5. **Organizes assets** - Moves to `wiki/raw/` organized by type
6. **Creates context map** - Generates persistent documentation index

**When to Use**:
- Setting up documentation infrastructure for first time
- Reorganizing scattered documentation
- Consolidating docs from multiple directories
- Before running cel.wiki.read or cel.wiki.write

**What Gets Moved**:

**Markdown files** (`.md`):
- From: Any location in project
- To: `wiki/` (flat structure)
- Exclusions: .git/, node_modules/, .venv/, etc.

**Static assets** (`.pdf`, `.txt`, `.docx`, etc.):
- From: Any location in project
- To: `wiki/raw/` organized by type
- Types: PDFs, Transcripts, Exports, Images

**Example**:
```bash
/cel.wiki.init
# Creates wiki/ and wiki/raw/ directories
# Scans entire project for documentation
# Consolidates all .md files to wiki/
# Organizes assets in wiki/raw/
```

**Important Notes**:
- Safe to run multiple times
- Automatically excludes dependency directories
- Creates standardized wiki structure
- Preserves original file metadata

---

## cel.wiki.read

**Purpose**: Analyzes project documentation and creates persistent context cache for reuse.

**Usage**:
```
/cel.wiki.read           # Scan or use cache
/cel.wiki.read refresh   # Force rescan
```

**What It Does**:

1. **Checks for existing context** - Looks for `.cel/context.md`
2. **Analyzes documentation** - Performs deep ingestion of all .md files
3. **Extracts key information**:
   - Project purpose and architecture
   - Tech stack and key technologies
   - Important workflows and patterns
   - Documentation map (where info lives)
4. **Creates cache file** - Stores context in `.cel/context.md`
5. **Computes hashes** - Tracks file changes for future updates

**When to Use**:
- First time setting up project context
- Before running cel.wiki.write (auto-included)
- Need to understand project knowledge
- Want to persist context across sessions

**Cache Behavior**:
- **Cache Hit** (files unchanged) - Loads from cache instantly
- **Cache Miss** (files changed) - Rescans and updates cache
- **Force Refresh** (`refresh` arg) - Forces rescan regardless

**Example**:
```bash
# First time - scans documentation
/cel.wiki.read
# Output: "Project context loaded and cached"

# Second time - uses cache (faster)
/cel.wiki.read
# Output: "Project context loaded from cache"

# Force update
/cel.wiki.read refresh
# Output: "Project re-scanned, context updated"
```

**Important Notes**:
- Creates `.cel/context.md` for persistence
- Stores MD5 hashes of all .md files
- Automatically excluded from git (.cel/ in .gitignore)
- Used internally by cel.wiki.write and cel.wiki.simplify

---

## cel.wiki.simplify

**Purpose**: Audits and simplifies wiki documentation by consolidating redundancy and eliminating duplicates.

**Usage**:
```
/cel.wiki.simplify       # Interactive mode (requires approval)
/cel.wiki.simplify force # Auto-mode (implements automatically)
```

**What It Does**:

1. **Analyzes all wiki files** - Reads and parses markdown documentation
2. **Identifies issues**:
   - Duplication and redundancy
   - Inconsistent terminology
   - Contradictions between files
   - Excessive verbosity
3. **Creates consolidation plan** - Proposes specific improvements
4. **Requests approval** - Shows plan and asks for confirmation
5. **Implements improvements** - Consolidates, removes duplicates, improves structure

**When to Use**:
- After generating documentation with cel.wiki.write
- When wiki has grown and needs cleanup
- Before major documentation review
- Want to optimize documentation efficiency

**Usage Modes**:
```bash
# Interactive - shows plan, asks approval
/cel.wiki.simplify

# Auto-mode - implements without confirmation
/cel.wiki.simplify force
```

**Example**:
```bash
/cel.wiki.simplify
# Shows identified issues:
# - "setup.md and installation.md have 60% duplication"
# - "api.md uses 'REST API' and 'API' inconsistently"
# 
# Proposes consolidation plan
# Asks: "Proceed with consolidation? [Y/n]"
```

**Important Notes**:
- Only analyzes `wiki/` directory (not wiki/raw/)
- Preserves all essential information
- Uses project context to inform decisions
- Force flag skips confirmation step

---

## cel.wiki.write

**Purpose**: Generates baseline project documentation by analyzing codebase and creating comprehensive wiki.

**Usage**:
```
/cel.wiki.write           # Generate/update docs (preserves existing)
/cel.wiki.write overwrite # Regenerate all from scratch
```

**What It Does**:

1. **Initializes wiki** - Creates wiki structure (via cel.wiki.init)
2. **Loads context** - Analyzes project knowledge (via cel.wiki.read)
3. **Scans codebase** - Analyzes project structure and technologies
4. **Generates documentation**:
   - `overview.md` - Project overview and architecture
   - `structure.md` - Directory layout and organization
   - `setup.md` - Installation and environment setup
   - `development.md` - Development workflow
   - `skills.md` - Skill reference (in this project)
   - Additional files as needed
5. **Simplifies output** - Consolidates and cleans up (via cel.wiki.simplify)

**When to Use**:
- Setting up documentation for new/existing project
- Regenerating docs after major changes
- Want automated baseline documentation
- Need comprehensive project documentation

**Usage Modes**:
```bash
# Default - generates new, updates existing, preserves customizations
/cel.wiki.write

# Overwrite - regenerates all documentation from scratch
/cel.wiki.write overwrite
```

**Generated Files**:
| File | Content |
|------|---------|
| `overview.md` | Project purpose, tech stack, architecture |
| `structure.md` | Directory layout, file organization |
| `setup.md` | Installation, environment setup |
| `development.md` | Development workflow, processes |
| `skills.md` | Skill reference and usage (project-specific) |

**Example**:
```bash
# Generate documentation
/cel.wiki.write
# Creates/updates overview.md, structure.md, setup.md, etc.
# Preserves any custom documentation
# Simplifies and deduplicates content

# Or regenerate everything fresh
/cel.wiki.write overwrite
# Deletes all existing wiki files
# Generates everything from scratch
```

**Important Notes**:
- Automatically calls cel.wiki.init and cel.wiki.read
- Default mode preserves existing customizations
- Overwrite mode clears existing documentation
- Auto-invokes cel.wiki.simplify at end
- Creates minimal but comprehensive documentation

---

## Skill Invocation Patterns

### In GitHub Copilot Chat

```
/cel.wiki.write
/cel.src.review auto
/cel.git.sync
```

### In Other Agents

Refer to your agent's documentation for skill invocation syntax. Common patterns:

```
skill: "cel.wiki.write"
skill: "cel.src.review [auto]"
skill: "cel.git.sync"
```

## Skill Dependencies

```
cel.wiki.write
  ├→ cel.wiki.init (initializes structure)
  ├→ cel.wiki.read (loads context)
  └→ cel.wiki.simplify (cleans output)

cel.wiki.read
  └→ Used by: cel.wiki.write, cel.wiki.simplify

cel.wiki.simplify
  └→ Called by: cel.wiki.write, or invoked standalone

cel.git.sync
  └→ Uses: git CLI only

cel.screen.read
  └→ Standalone, uses system screenshot API

cel.src.review
  └→ Standalone, analyzes documentation files
```

## Related Documentation

- [Overview](overview.md) - Project purpose and architecture
- [Development](development.md) - How to work with skills
- [Setup](setup.md) - Installation and configuration
- [Troubleshoot](troubleshoot.md) - Common issues and solutions
