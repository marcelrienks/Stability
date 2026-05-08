---
name: cel.wiki.write
description: "Generate and update project documentation by scanning codebase and existing context. Usage: `/cel.wiki.write [overwrite]` - use [overwrite] to replace all existing documents with newly generated ones."
---

# Write Wiki Documentation

This skill generates baseline project documentation by analyzing the codebase, understanding project structure, functionality, and intent, then creating minimal but comprehensive documentation in the wiki directory. It leverages existing documentation and context to create documentation that fully covers the known scope of the project.

## What This Skill Does

When you invoke this skill, it will:

1. **Initialize** wiki structure if not present (using cel.wiki.init)
2. **Load existing context** from documentation and codebase (using cel.wiki.read)
3. **Scan the codebase** for structure, technologies, patterns, and key components
4. **Generate documentation** files covering project overview, setup, development, and configuration
5. **Update existing documentation** with new findings (or replace all if `overwrite` flag is used)
6. **Simplify and cleanup** the generated documentation (using cel.wiki.simplify with force flag)

## How to Use This Skill

### Option 1: Generate/Update Documentation (Default)
```
/cel.wiki.write
```

Analyzes the codebase and generates new documentation files. If files exist, updates them with new findings and context. Preserves existing documentation structure while adding missing pieces.

### Option 2: Overwrite All Documentation
```
/cel.wiki.write overwrite
```

Performs a complete scan and regenerates ALL documentation from scratch, replacing existing documentation with newly generated content. Use this when you want a fresh baseline of documentation.

## Workflow

The skill executes a comprehensive 6-phase process:

### Phase 1: Initialize Wiki Structure
1. **Check for wiki directory**: Determine if `wiki/` and `wiki/raw/` directories exist at project root
2. **Create if missing**: Invoke cel.wiki.init to create standardized wiki structure if needed
3. **Report status**: Confirm wiki structure is ready for documentation

### Phase 2: Load Existing Context
1. **Check for context cache**: Look for `.cel/context.md` from previous cel.wiki.read invocations
2. **Load project knowledge**: Invoke cel.wiki.read to understand existing documentation
3. **Cache status**: Report whether context was loaded from cache or freshly scanned

### Phase 3: Codebase Analysis
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

### Phase 4: Generate Documentation Files

Based on analysis, generate or update minimal documentation files:

1. **overview.md** - Project purpose, tech stack, architecture overview
   - What the project does
   - Key technologies and versions
   - High-level architecture
   - Key workflows or use cases

2. **structure.md** - Directory layout and file organization
   - Project folder structure with descriptions
   - Purpose of each major directory
   - Key files and their roles
   - File organization conventions

3. **setup.md** - Environment setup and installation
   - System requirements
   - Dependency installation steps
   - Environment configuration (env variables, etc.)
   - Initial setup checklist

4. **development.md** - Development workflow and processes
   - Local development setup
   - Running tests
   - Building the project
   - Common development tasks
   - Code conventions and patterns

5. **config.md** - Configuration reference (if applicable)
   - Configuration options
   - Environment variables
   - Configuration file formats
   - Default values and overrides

6. **scripts.md** - Available scripts and automation (if applicable)
   - Purpose of each script
   - How to run scripts
   - Script parameters and options
   - Common workflows

Additional files generated as needed:
- **api.md** - API documentation (if applicable)
- **deployment.md** - Deployment procedures (if applicable)
- **troubleshoot.md** - Common issues and solutions

### Phase 5: Content Management

**Default Mode** (no `overwrite` flag):
- Create new documentation files that don't exist
- Update existing files with new findings and context
- Merge new information with existing documentation
- Preserve any customizations in existing files

**Overwrite Mode** (`overwrite` flag):
- Generate ALL documentation files from scratch
- Replace all existing documentation with newly generated content
- Delete superseded files
- Create fresh structure based on current codebase analysis

### Phase 6: Simplify and Cleanup
1. **Invoke cel.wiki.simplify**: Automatically run with `force` flag
2. **Auto-cleanup**: Consolidate redundancy and ensure consistency
3. **No confirmation needed**: force flag bypasses manual confirmation
4. **Final structure**: Present cleaned-up and simplified wiki

## Documentation Generation Strategy

The skill generates **minimal but comprehensive** documentation:

- **Minimal**: Only include what's necessary; avoid redundancy
- **Comprehensive**: Cover all known functionality, intent, and structure
- **Contextual**: Use existing documentation and context to inform generation
- **Maintainable**: Simple language, clear structure, easy to update
- **Scannable**: Clear headings, bullet points, organized sections

## File Naming Convention

All generated documentation follows the single-word, lowercase format:
- `overview.md` - Project overview
- `structure.md` - Project structure
- `setup.md` - Installation and setup
- `development.md` - Development guide
- `config.md` - Configuration reference
- `scripts.md` - Available scripts
- `api.md` - API documentation
- `deployment.md` - Deployment procedures
- `troubleshoot.md` - Troubleshooting guide

## When to Use This Skill

Use this skill when you want to:
- Generate baseline documentation from scratch
- Update documentation with new codebase analysis
- Create comprehensive project overview documentation
- Establish consistent documentation structure
- Ensure documentation covers all known functionality and context
- Refresh documentation after major project changes (with `overwrite`)

## How It Works with Other Skills

- **cel.wiki.init**: Called automatically to create wiki structure if needed
- **cel.wiki.read**: Called to load existing context and understand project
- **cel.wiki.simplify**: Called automatically with `force` flag to cleanup generated docs
- **Intent**: Create the baseline documentation that cel.wiki.read and cel.wiki.simplify enhance

## Example Workflows

### Initial Documentation Generation
```
User: /cel.wiki.write
Copilot:
1. Checks for wiki structure (creates if needed via cel.wiki.init)
2. Loads existing context (via cel.wiki.read)
3. Scans codebase for structure, technologies, and patterns
4. Generates overview.md, structure.md, setup.md, development.md, etc.
5. Invokes cel.wiki.simplify with force flag
6. Reports completed documentation baseline
```

### Refresh Existing Documentation
```
User: /cel.wiki.write overwrite
Copilot:
1. Checks for wiki structure
2. Loads existing context
3. Scans codebase (forcing fresh analysis)
4. Regenerates ALL documentation from scratch
5. Replaces existing documentation
6. Invokes cel.wiki.simplify with force flag
7. Reports refreshed documentation baseline
```

## Important Notes

- The skill is designed to work with cel.wiki.init, cel.wiki.read, and cel.wiki.simplify
- **Phase 2** automatically loads context to inform documentation generation
- **Phase 6** automatically cleans up generated documentation with force flag (no manual confirmation)
- The skill preserves critical information while generating minimal, focused documentation
- Uses codebase analysis in addition to existing documentation for comprehensive understanding
- The `overwrite` flag enables complete documentation refresh when needed
- Generated documentation is automatically simplified and consolidated
- Single-word file names in lowercase provide consistent documentation conventions
