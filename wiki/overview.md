# Stability Project Overview

## Project Purpose

Stability is a curated collection of **CEL (Coding Agent Skills)** — reusable, modular skill implementations designed to extend agent capabilities. The project serves as a centralized repository for agent skills that enhance productivity across multiple platforms (agents, GitHub Copilot, Claude).

## Key Technologies & Stack

- **Language**: Bash scripting, Markdown documentation
- **Architecture**: Modular skill-based design with YAML frontmatter metadata
- **Distribution**: Cross-platform skill deployment (WSL, macOS, Linux, Windows)
- **Configuration**: OpenCode.ai compatible framework
- **Behavioral Guidelines**: LLM-optimized coding practices (claude.md)

## Project Scope

The project provides 7 core CEL skills organized in the `skills/` directory, plus supporting configuration and documentation infrastructure.

## Core Skills Included

| Skill | Purpose |
|-------|---------|
| **cel.git.sync** | Automated git workflow (stage, commit, pull, push with conflict resolution) |
| **cel.screen.read** | Screenshot analysis tool for visual debugging context |
| **cel.src.review** | Documentation review (detects fallacies, contradictions, inconsistencies) |
| **cel.wiki.init** | Initialize standardized wiki folder structure |
| **cel.wiki.read** | Persistent project context analysis and caching |
| **cel.wiki.simplify** | Wiki audit, consolidation, and optimization |
| **cel.wiki.write** | Generate baseline documentation from codebase analysis |

## High-Level Architecture

```
stability/
├── skills/                    # Reusable skill implementations
│   ├── cel.git.sync/         # Git automation
│   ├── cel.screen.read/      # Screenshot analysis
│   ├── cel.src.review/       # Documentation review
│   ├── cel.wiki.*/           # Wiki management (init, read, simplify, write)
│   └── deploy-cel-skills.sh  # Cross-platform deployment
├── configuration files        # Project config (claude.md, opencode.json)
└── wiki/                      # Generated documentation
```

## Key Workflows

### 1. Skill Deployment
Deploy skills to local agent environments (agents, copilot, claude) across Windows, WSL, macOS, and Linux.

### 2. Documentation Generation
Auto-generate comprehensive project documentation by analyzing codebase structure, dependencies, and existing context.

### 3. Git Synchronization
Streamlined git workflow with intelligent commit messages, conflict resolution, and safe push/pull operations.

### 4. Screenshot Analysis
Visual debugging tool for examining code editor state, terminal output, and error messages in agent sessions.

### 5. Documentation Quality Assurance
Systematic review of documentation for logical fallacies, contradictions, and inconsistencies.

## Project Configuration

- **claude.md**: LLM behavioral guidelines emphasizing simplicity, clarity, and surgical code changes
- **opencode.json**: OpenCode framework configuration with model settings and formatters
- **.gitignore**: Standard Git ignores for keeping repository clean

## Development Focus

This project prioritizes:
- **Modularity**: Each skill is self-contained with YAML metadata
- **Reusability**: Skills designed for cross-platform deployment
- **Documentation Quality**: Comprehensive skill descriptions and usage guides
- **Automation**: Reduced manual overhead through scripted deployment and documentation
