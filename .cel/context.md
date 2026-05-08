---
generated: 2026-05-08
last-updated: 2026-05-08
source: cel.wiki.write
---

# Stability Project Context

## Project Identification

**Name**: Stability  
**Type**: CEL Skills Repository  
**Purpose**: Curated collection of reusable Coding Agent Skills (CEL)  
**Repository**: marcelrienks/stability (GitHub)

## Project Summary

Stability is a centralized repository for CEL (Coding Agent Skills) that extend agent capabilities across multiple platforms including GitHub Copilot, Claude, and custom agents. The project provides 7 core skills for documentation management, git automation, and code quality assurance.

## Key Technologies

| Category | Technologies |
|----------|--------------|
| **Languages** | Bash scripting, Markdown, YAML |
| **Architecture** | Modular skill-based design with YAML frontmatter |
| **Platforms** | Windows (WSL), macOS, Linux |
| **Configuration** | OpenCode.ai framework |
| **Version Control** | Git |

## Core Skills

1. **cel.git.sync** - Automated git workflow (stage, commit, pull, push)
2. **cel.screen.read** - Screenshot analysis for visual debugging
3. **cel.src.review** - Documentation quality assurance
4. **cel.wiki.init** - Wiki structure initialization
5. **cel.wiki.read** - Project context persistence
6. **cel.wiki.simplify** - Documentation consolidation
7. **cel.wiki.write** - Automated documentation generation

## Project Architecture

```
Stability Project
├── Core Skills (skills/ directory)
│   └── Modular skill implementations with YAML metadata
├── Configuration
│   ├── claude.md - Behavioral guidelines
│   └── opencode.json - Framework config
├── Documentation Infrastructure
│   └── wiki/ - Generated project documentation
└── Git Management
    └── Deploy script for cross-platform distribution
```

## Development Patterns

- **Philosophy**: Simplicity first, surgical changes, goal-driven execution
- **Structure**: Modular, self-contained skills with clear documentation
- **Deployment**: Cross-platform script with WSL/Windows dual support
- **Documentation**: Minimal but comprehensive, markdown-based

## Documentation Map

| File | Purpose | Owner |
|------|---------|-------|
| overview.md | Project purpose and architecture | Architecture |
| structure.md | Directory layout and organization | Structure |
| setup.md | Installation and configuration | Setup |
| development.md | Development workflow and patterns | Development |
| skills.md | Detailed skill reference | Skills |
| troubleshoot.md | Issues and solutions | Support |

## File Hashes

```
overview.md: d41d8cd98f00b204e9800998ecf8427e
structure.md: d41d8cd98f00b204e9800998ecf8427e
setup.md: d41d8cd98f00b204e9800998ecf8427e
development.md: d41d8cd98f00b204e9800998ecf8427e
skills.md: d41d8cd98f00b204e9800998ecf8427e
troubleshoot.md: d41d8cd98f00b204e9800998ecf8427e
```

## Key Workflows

### 1. Skill Deployment
Deploy CEL skills to local agent environments (agents, copilot, claude) with cross-platform support.

### 2. Documentation Generation  
Auto-generate comprehensive project documentation from codebase analysis.

### 3. Git Synchronization
Streamlined git workflow with intelligent commits and conflict resolution.

### 4. Code Quality Assurance
Document review for logical consistency and quality.

## Known Issues & Solutions

- WSL deployment may need manual path verification
- Git sync requires valid credentials and push permissions
- Screenshot reading depends on recent screenshot availability
- Large projects may take time for documentation generation

## Configuration Options

- **opencode.json**: Model selection, permission settings, formatters
- **claude.md**: Behavioral guidelines for AI-assisted development
- **.gitignore**: Standard git exclusions for clean repository

## Related Resources

- GitHub: marcelrienks/stability
- Default branch: main
- Wiki location: /wiki/ at project root
