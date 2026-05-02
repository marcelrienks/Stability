---
name: cel.simplify-docs
description: Audit and simplify project documentation by consolidating redundancy and eliminating duplicates while preserving essential information.
---

# Simplify Docs

This skill provides a comprehensive documentation audit and simplification service. It reads and analyzes all markdown files within a project's documentation directory, identifies inefficiencies and inconsistencies, creates a consolidation and simplification plan, and executes the improvements while preserving all essential information.

## What This Skill Does

When you invoke this skill, it will:

1. **Analyze** all markdown documentation files in the project
2. **Identify issues** including duplication, redundancy, inconsistency, contradictions, and excessive verbosity
3. **Create a plan** for simplification and consolidation
4. **Request confirmation** before making any changes
5. **Implement** the improvements while preserving key value

## How to Use This Skill

### Option 1: Using the Slash Command
```
/cel.simplify-docs
```

### Option 2: Calling as a Named Skill
```
skill: "cel.simplify-docs"
```

After invoking the skill, you can then ask questions or provide guidance about the documentation review, such as:
- "Analyze my docs directory"
- "What redundancies do you see?"
- "How would you consolidate these files?"
- "Proceed with simplification"

## Workflow

The skill executes a comprehensive 4-fold process:

### Phase 1: Analyze
The skill performs a thorough audit of all markdown files in the project's `docs/` directory:

1. **Locate Documentation**: Find all `.md` files in the project's documentation directory
2. **Read Content**: Load and parse all markdown files, extracting:
   - File names and purposes
   - Headers and structure
   - Content and key information
   - Metadata and frontmatter (if present)
3. **Identify Issues**: Analyze each file and across files for:
   - **Duplication**: Identical or near-identical content appearing in multiple files
   - **Redundancy**: Overlapping information that could be consolidated
   - **Inconsistency**: Conflicting information, terminology, or formatting
   - **Contradictions**: Direct conflicts between statements across files
   - **Verbosity**: Unnecessarily lengthy explanations that could be condensed
4. **Map Relationships**: Identify connections between files and content
5. **Assess Value**: Determine the key value each file brings to the documentation

### Phase 2: Plan
Based on the analysis, the skill creates a detailed consolidation and simplification plan:

1. **Group Related Content**: Identify files that should be consolidated
2. **Eliminate Duplicates**: Flag redundant content for removal
3. **Resolve Contradictions**: Recommend authoritative versions
4. **Propose File Structure**: Suggest simplified file organization
5. **Define Naming**: Recommend single-word file names in lowercase format:
   - Examples: readme.md, setup.md, install.md, guide.md, api.md, config.md, faq.md, troubleshoot.md
6. **Create Execution Steps**: Detail specific actions (consolidations, deletions, rewrites)
7. **Estimate Impact**: Show content reduction and quality improvements

### Phase 3: Confirmation
The skill presents the plan to you for review and approval:

1. **Display Plan**: Show all proposed changes
2. **Highlight Decisions**: Explain key consolidation and elimination choices
3. **Request Approval**: Present the plan summary. Respond with "Proceed", "Refine [specific concern]", or propose changes
4. **Address Concerns**: Accept feedback and adjust the plan if needed
5. **Finalize**: Once you approve, proceed to implementation

### Phase 4: Implement
Execute the approved consolidation and simplification plan:

1. **Create New Files**: Generate consolidated markdown files with unified content
2. **Apply Naming**: Rename files to single-word, lowercase format
3. **Preserve Value**: Ensure all critical information is retained
4. **Remove Obsolete**: Delete redundant or superseded files
5. **Update Cross-References**: Fix any broken links or references
6. **Verify Structure**: Confirm the new documentation structure is complete
7. **Generate Summary**: Provide a before/after comparison showing improvements

## Documentation File Naming Convention

All simplified documentation files should follow the single-word, lowercase format:

**Standard Files:**
- `readme.md` - Project overview and quick start
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

## When to Use This Skill

Use this skill when you want to:
- Audit your documentation for inconsistencies and inefficiencies
- Reduce documentation clutter and complexity
- Consolidate overlapping content into unified sources
- Standardize documentation file naming and structure
- Improve documentation maintainability and clarity
- Preserve essential information while removing noise

## Example Workflow

```
User: /cel.simplify-docs
Copilot:
1. Analyzes all markdown files in the docs directory
2. Identifies duplication, redundancy, contradictions, and verbosity
3. Creates a consolidation plan with specific file merges and simplifications
4. Presents the plan for your review and confirmation
5. Upon approval, implements the changes
6. Reports on improvements and new documentation structure
```

## Important Notes

- The skill analyzes **all** markdown files in the project's documentation directory
- **Phase 3 (Confirmation)** is mandatory - no changes are made without explicit approval
- All critical information is preserved during consolidation
- Single-word file names in lowercase follow consistent documentation conventions
- The skill maintains version control awareness - changes are isolated and can be reviewed
- Broken links and cross-references are automatically updated
- **File Naming**: ONLY single-word names in lowercase (e.g., setup.md, not getting_started.md); all files including readme.md must be lowercase
- The skill provides a detailed before/after summary showing consolidation benefits
- Redundant and duplicate files are flagged for removal, not archived

