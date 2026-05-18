---
name: cel.wiki.write
description: "Generate and update project documentation by scanning codebase and existing context. Usage: `/cel.wiki.write [overwrite]`"
---

# Write Wiki Documentation

This skill generates baseline project documentation by analyzing the codebase, understanding project structure, functionality, and intent, then creating minimal but comprehensive documentation in the wiki directory. It leverages existing documentation and context to create documentation that fully covers the known scope of the project.

## Workflow

The skill executes the following process:

### 1. Initialize & Load Context
Create wiki structure if needed (via cel.wiki.init) and load existing project context (via cel.wiki.read).

### 2. Codebase Analysis
Scan the entire project structure to understand:

1. **Project Structure**:
   - Directory layout and organization
   - Key folders and their purposes
   - File distribution across project

2. **Technology & Stack**:
   - Programming languages used
   - Frameworks and major dependencies
   - Build tools and scripts
   - Package managers (npm, pip, etc.)
   - Configuration file types (package.json, pyproject.toml, etc.)

3. **Key Components**:
   - Entry points (main.ts, app.py, index.js, etc.)
   - Configuration files (env templates, config files)
   - Scripts and automation (Makefile, scripts/, etc.)
   - Dependencies and versions
   - API patterns or exposed interfaces

4. **Development Patterns**:
   - Folder conventions (src/, test/, dist/, etc.)
   - Module/package structure
   - Testing setup (test files, test configuration)
   - Build process or compilation steps
   - Development vs. production patterns

5. **Documentation Existing Context**:
   - README.md purpose and content
   - Existing wiki files and their scope
   - Configuration patterns
   - Known workflows or processes

### 3. Generate Documentation Files

Based on analysis, generate or update minimal documentation files: `overview.md`, `structure.md`, `setup.md`, `development.md`, `config.md`, `scripts.md`, and optionally `api.md`, `deployment.md`, `troubleshoot.md` (based on detected project type).

### 4. Manage Content & Simplify
Apply content management based on flags (default: update existing; `overwrite`: replace all), then invoke cel.wiki.simplify for auto-consolidation.

## Important Notes

- The skill is designed to work with cel.wiki.init, cel.wiki.read, and cel.wiki.simplify
- **Phase 2** automatically loads context to inform documentation generation
- **Phase 6** automatically cleans up generated documentation with force flag (no manual confirmation)
- The skill preserves critical information while generating minimal, focused documentation
- Uses codebase analysis in addition to existing documentation for comprehensive understanding
- The `overwrite` flag enables complete documentation refresh when needed
- Generated documentation is automatically simplified and consolidated
- Single-word file names in lowercase provide consistent documentation conventions
