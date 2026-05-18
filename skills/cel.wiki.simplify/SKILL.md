---
name: cel.wiki.simplify
description: "Audit and simplify project wiki by consolidating redundancy and eliminating duplicates. Usage: `/cel.wiki.simplify [force]`"
---

# Simplify Wiki

This skill provides a comprehensive wiki audit and simplification service. It reads and analyzes all markdown files within a project's wiki directory, identifies inefficiencies and inconsistencies, creates a consolidation and simplification plan, and executes the improvements while preserving all essential information.

## What This Skill Does

When you invoke this skill, it will:

1. **Analyze** all markdown documentation files within the wiki directory (not wiki/raw/) using full project context
2. **Identify issues** including duplication, redundancy, inconsistency, contradictions, and excessive verbosity
3. **Create a plan** for simplification and consolidation
4. **Request confirmation** before making any changes
5. **Implement** the improvements while preserving all essential information

**Note:** Analysis scope is the wiki directory only (modifications apply to wiki/ files), but the skill leverages full project context from the persisted context file (.cel/context.md) and the entire codebase to determine best solutions.

## Workflow

The skill executes a comprehensive 4-fold process:

### Phase 1: Analyze
The skill performs a thorough audit of all markdown files in the wiki directory (not wiki/raw/) while leveraging full project context:

1. **Load Project Context**: 
   - Read the persisted context file (.cel/context.md) if available
   - Scan the codebase as needed to understand project structure, technologies, and patterns
2. **Locate Documentation**: Find all `.md` files in the `wiki/` directory (excluding wiki/raw/)
3. **Read Content**: Load and parse all markdown files, extracting:
   - File names and purposes
   - Headers and structure
   - Content and key information
   - Metadata and frontmatter (if present)
4. **Identify Issues**: Analyze each file and across files for:
   - **Duplication**: Identical or near-identical content appearing in multiple files
   - **Redundancy**: Overlapping information that could be consolidated
   - **Inconsistency**: Conflicting information, terminology, or formatting
   - **Contradictions**: Direct conflicts between statements across files
   - **Verbosity**: Unnecessarily lengthy explanations that could be condensed
5. **Map Relationships**: Identify connections between files and content
6. **Assess Value**: Determine the key value each file brings to the documentation

### Phase 2: Plan
Based on the analysis (informed by full project context), the skill creates a detailed consolidation and simplification plan for wiki files:

1. **Group Related Content**: Identify files that should be consolidated
2. **Eliminate Duplicates**: Flag redundant content for removal
3. **Resolve Contradictions**: Recommend authoritative versions
4. **Propose File Structure**: Suggest simplified file organization
5. **Define Naming**: Recommend single-word file names in lowercase format:
   - Examples: readme.md, setup.md, install.md, guide.md, api.md, config.md, faq.md, troubleshoot.md
6. **Create Execution Steps**: Detail specific actions (consolidations, deletions, rewrites) for wiki/ files only
7. **Estimate Impact**: Show content reduction and quality improvements

### Phase 3: Confirmation
The skill presents the plan to you for review and approval (unless `force` flag is used):

1. **Display Plan**: Show all proposed changes
2. **Highlight Decisions**: Explain key consolidation and elimination choices
3. **Request Approval**: Present the plan summary. Respond with "Proceed", "Refine [specific concern]", or propose changes (skipped if `force` flag is used)
4. **Address Concerns**: Accept feedback and adjust the plan if needed (skipped if `force` flag is used)
5. **Finalize**: Once you approve (or if `force` flag is passed), proceed to implementation

### Phase 4: Implement
Execute the approved consolidation and simplification plan on wiki/ files:

1. **Create New Files**: Generate consolidated markdown files with unified content in wiki/
2. **Apply Naming**: Rename files to single-word, lowercase format
3. **Preserve Value**: Ensure all critical information is retained
4. **Remove Obsolete**: Delete redundant or superseded files from wiki/
5. **Update Cross-References**: Fix any broken links or references within wiki/
6. **Verify Structure**: Confirm the new documentation structure is complete
7. **Generate Summary**: Provide a before/after comparison showing improvements

## Documentation File Naming Convention

All simplified documentation files should follow the single-word, lowercase format:

**Standard Files (in wiki/ only):**
- `setup.md` - Installation and environment setup
- `install.md` - Installation instructions
- `guide.md` - Comprehensive user guide
- `tutorial.md` - Step-by-step tutorials
- `api.md` - API documentation
- `config.md` - Configuration reference
- `faq.md` - Frequently asked questions
- `troubleshoot.md` - Troubleshooting and common issues
- `contributing.md` - Contribution guidelines
- `license.md` - License information
- `changelog.md` - Version history and changes

**Note:** `README.md` always remains at project root and is NOT created in the wiki/ directory.

## When to Use This Skill

Use this skill when you want to:
- Audit your documentation for inconsistencies and inefficiencies
- Reduce documentation clutter and complexity
- Consolidate overlapping content into unified sources
- Standardize documentation file naming and structure
- Improve documentation maintainability and clarity
- Preserve essential information while removing noise

## Example Workflow

### Interactive Mode (Default)
```
User: /cel.wiki.simplify
Copilot:
1. Analyzes all markdown files in the wiki directory
2. Identifies duplication, redundancy, contradictions, and verbosity
3. Creates a consolidation plan with specific file merges and simplifications
4. Presents the plan for your review and confirmation
5. Upon approval, implements the changes
6. Reports on improvements and new documentation structure
```

### Force Mode (Auto-Implement)
```
User: /cel.wiki.simplify force
Copilot:
1. Analyzes all markdown files in the wiki directory
2. Identifies duplication, redundancy, contradictions, and verbosity
3. Creates a consolidation plan with specific file merges and simplifications
4. Auto-implements the best solutions without waiting for confirmation
5. Reports on improvements and new documentation structure
```

## Important Notes

- **Modification scope**: The skill modifies **only** markdown files in the `wiki/` directory (NOT wiki/raw/)
- **Analysis scope**: Uses full project context (persisted context file and codebase) to inform analysis and solutions
- **Phase 3 (Confirmation)** is mandatory by default - no changes are made without explicit approval
- Use the `force` flag to skip Phase 3 and auto-implement the best solutions without confirmation
- All critical information is preserved during consolidation
- Single-word file names in lowercase follow consistent documentation conventions
- The skill maintains version control awareness - changes are isolated and can be reviewed
- Broken links and cross-references are automatically updated
- **File Naming**: ONLY single-word names in lowercase for wiki/ files (e.g., setup.md, not getting_started.md). README.md must remain at project root and is not modified or moved by this skill.
- The skill provides a detailed before/after summary showing consolidation benefits
- Redundant and duplicate files are flagged for removal, not archived
- **Force Mode**: Use `force` argument to auto-implement changes without requiring manual approval (useful when called by cel.wiki.write)

