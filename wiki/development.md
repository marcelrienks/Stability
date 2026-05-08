# Development Workflow

## Development Environment Setup

### Prerequisites

1. **Clone the repository** (see [setup.md](setup.md))
2. **Verify Git is configured**:
   ```bash
   git config user.name
   git config user.email
   ```
3. **Deploy skills locally**:
   ```bash
   cd skills
   ./deploy-cel-skills.sh agents
   ```

## Working with Skills

### Skill File Structure

Each skill is a self-contained directory with minimal structure:

```
skills/cel.example-skill/
└── SKILL.md                   # Complete skill documentation
```

### SKILL.md Format

Every SKILL.md must include:

```yaml
---
name: cel.skill-name
description: "Brief one-liner and usage. Usage: `/cel.skill-name [args]`"
---

# Full Skill Title

[Complete documentation following the pattern...]
```

### Creating a New Skill

1. **Create directory**:
   ```bash
   mkdir skills/cel.new-skill
   ```

2. **Create SKILL.md** with YAML frontmatter

3. **Follow documentation pattern**:
   - Clear "What This Skill Does" section
   - Workflow steps numbered
   - Usage examples
   - When to use this skill

4. **Deploy the new skill**:
   ```bash
   ./deploy-cel-skills.sh agents
   ```

## Documentation Development

### Generating Project Documentation

Use the cel.wiki.write skill to auto-generate wiki documentation:

```bash
# Generate/update documentation (preserves existing)
/cel.wiki.write

# Regenerate all documentation from scratch
/cel.wiki.write overwrite
```

### Organizing Wiki Files

The `wiki/` directory contains all project documentation:

- **Single-word, lowercase filenames**: `overview.md`, `setup.md`, `development.md`
- **Flat structure**: All files in `wiki/` root (not nested)
- **Static assets**: Stored in `wiki/raw/` organized by type

### Wiki File Standards

| File | Purpose | Owner |
|------|---------|-------|
| `overview.md` | Project overview, tech stack, architecture | Architecture lead |
| `structure.md` | Directory layout and organization | Technical writer |
| `setup.md` | Installation and environment setup | DevOps/Setup owner |
| `development.md` | Development workflow and patterns | Development lead |
| `skills.md` | Skill reference and detailed usage | Skills maintainer |
| `troubleshoot.md` | Common issues and solutions | Support/QA |

### Reviewing Documentation Quality

Use cel.src.review to audit documentation:

```bash
# Interactive review (asks for confirmation on changes)
/cel.src.review

# Auto-fix mode (implements best solutions automatically)
/cel.src.review auto

# Specific phase reviews
/cel.src.review fallacies        # Check for logical errors
/cel.src.review contradictions   # Find conflicting statements
/cel.src.review inconsistencies  # Standardize terminology/format
```

### Simplifying Documentation

Consolidate and clean up wiki documentation:

```bash
# Interactive mode (requires approval)
/cel.wiki.simplify

# Auto-mode (implements improvements without confirmation)
/cel.wiki.simplify force
```

## Development Patterns

### Coding Philosophy

Follow the behavioral guidelines in `claude.md`:

1. **Think Before Coding** - State assumptions, surface tradeoffs
2. **Simplicity First** - Minimum code solving the problem
3. **Surgical Changes** - Touch only what you must
4. **Goal-Driven Execution** - Define success criteria, verify completion

### Skill Development Workflow

```
1. Create skill directory and SKILL.md
   ↓
2. Write comprehensive documentation
   ↓
3. Review documentation (cel.src.review)
   ↓
4. Deploy skill (./deploy-cel-skills.sh)
   ↓
5. Test skill in agent environment
   ↓
6. Iterate based on feedback
```

### Documentation Workflow

```
1. Edit/create markdown files in wiki/
   ↓
2. Use cel.src.review to check quality
   ↓
3. Use cel.wiki.simplify to consolidate
   ↓
4. Commit changes (cel.git.sync)
   ↓
5. Verify in wiki/ directory
```

## Git Workflow

### Standard Development Cycle

```bash
# 1. Make changes to skills or documentation
# (Edit files as needed)

# 2. Auto-sync with git (stage, commit, pull, push)
/cel.git.sync

# This will:
# - Stage all changes
# - Generate intelligent commit message
# - Pull latest from remote
# - Handle merge conflicts
# - Push to remote
```

### Manual Git Operations

If you need more control:

```bash
# Stage specific files
git add skills/cel.my-skill/SKILL.md

# Commit with custom message
git commit -m "Add new cel.my-skill documentation"

# Pull with conflict resolution
git pull origin main

# Push to remote
git push origin main
```

## Testing Skills

### In GitHub Copilot

1. Deploy skill to copilot target:
   ```bash
   ./deploy-cel-skills.sh copilot
   ```

2. Open VS Code and start a Copilot Chat
3. Invoke skill using `/` prefix:
   ```
   /cel.wiki.write
   ```

### In Other Agents

1. Deploy to appropriate target (agents, claude, etc.)
2. Verify skill files exist in deployment directory
3. Test invocation according to agent's skill syntax

## Debugging Skills

### Checking Skill Metadata

Verify SKILL.md frontmatter is correct:

```bash
# Check if yaml is valid
head -5 skills/cel.example-skill/SKILL.md
```

Should show:
```yaml
---
name: cel.example-skill
description: "..."
---
```

### Verifying Deployment

```bash
# Check deployment directory
ls -la ~/.agents/skills/cel.example-skill/

# Verify SKILL.md exists
cat ~/.agents/skills/cel.example-skill/SKILL.md
```

### Common Issues

| Issue | Solution |
|-------|----------|
| Skill not appearing | Check SKILL.md exists and has valid YAML frontmatter |
| Wrong skill name | Verify `name:` in frontmatter matches folder name |
| Skill fails to invoke | Check usage syntax in documentation matches skill name |
| Documentation not loading | Ensure wiki/ directory exists and files are .md format |

## Development Checklist

Before committing changes:

- [ ] Skill documentation is complete and clear
- [ ] YAML frontmatter is valid (name, description)
- [ ] Usage examples are provided
- [ ] All cross-references use correct file names
- [ ] Documentation passes cel.src.review
- [ ] Skills deploy successfully without errors
- [ ] Changes are staged with meaningful commit message
- [ ] All tests/verifications pass

## Related Documentation

- [Overview](overview.md) - Project purpose and architecture
- [Structure](structure.md) - Directory layout and organization
- [Setup](setup.md) - Installation and environment configuration
- [Skills](skills.md) - Detailed skill reference
- [Troubleshoot](troubleshoot.md) - Common issues and solutions
