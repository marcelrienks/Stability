---
name: cel.wiki.review
description: "Review project wiki documentation for fallacies, contradictions, and inconsistencies. Analyzes wiki/ directory and root README only. Usage: `/cel.wiki.review [auto]`"
---

# Wiki Documentation Review

This skill performs a comprehensive three-phase review of project wiki documentation (files in wiki/ directory and root README.md), systematically identifying and resolving fallacies, contradictions, and inconsistencies. Does not analyze files in wiki/raw/.

## Workflow Steps

### Phase 1: Fallacy Analysis
Identifies logical fallacies and unsupported claims in wiki documentation:

**Detects:**
- Appeal to authority (assuming wiki content is correct without verification)
- Self-contradictions (claiming both X and not-X in wiki structure)
- False attribution (claiming wiki files/sections cover topics they don't address)
- Vague scope ambiguity (unclear which wiki files document specific topics)
- Unsupported assumptions (stating facts about project/workflow without evidence)
- Incomplete documentation (critical wiki sections missing or inadequate)

**Interactive Process (unless `auto` mode):**
1. Identify and state each fallacy clearly with location and context
2. Explain why it's a fallacy
3. Present optional solutions for the user to choose from
4. Update codebase based on user selection
5. Move to next fallacy

### Phase 2: Contradiction Analysis
Identifies direct conflicts between statements within wiki documentation:

**Detects:**
- Documentation mismatches (wiki states one fact, root README contradicts it)
- Topic contradictions (same topic documented differently in different wiki files)
- Workflow conflicts (wiki describes steps in conflicting ways)
- Scope conflicts (same topic with different boundaries/definitions across wiki)
- Outdated vs. current information (conflicting versions of procedures)

**Interactive Process (unless `auto` mode):**
1. State each contradiction with both conflicting statements quoted
2. Explain the conflict and its impact
3. Present resolution options
4. Update codebase based on user selection
5. Move to next contradiction

### Phase 3: Inconsistency Analysis
Identifies inconsistencies in naming, format, terminology, and structure within wiki:

**Detects:**
- Wiki file organization inconsistencies (files scattered, unclear hierarchy)
- Formatting inconsistencies (headings, lists, code blocks formatted differently)
- Terminology inconsistencies (same concept called different names)
- Cross-wiki reference errors (broken links or outdated references)
- README vs. wiki organization mismatches (README doesn't align with wiki structure)

**Interactive Process (unless `auto` mode):**
1. Identify inconsistency and show the variants
2. Explain the impact (user confusion, invocation failures, etc.)
3. Present standardization options
4. Update codebase based on user selection
5. Move to next inconsistency

## How to Use This Skill

### Option 1: Slash Command
```
/cel.wiki.review                        # All phases, interactive mode (default)
/cel.wiki.review auto                   # All phases, auto-fix mode
/cel.wiki.review fallacies              # Fallacy analysis only, interactive
/cel.wiki.review contradictions         # Contradiction analysis only, interactive
/cel.wiki.review inconsistencies        # Inconsistency analysis only, interactive
/cel.wiki.review fallacies auto         # Fallacy analysis only, auto-fix
/cel.wiki.review contradictions auto    # Contradiction analysis only, auto-fix
/cel.wiki.review inconsistencies auto   # Inconsistency analysis only, auto-fix
```

### Option 2: Named Skill
```
skill: "cel.wiki.review"
skill: "cel.wiki.review auto"
skill: "cel.wiki.review fallacies"
```

## Workflow Example

**User Input:**
```
/cel.wiki.review
```

**Copilot Response:**

```
Starting wiki documentation review...

=== PHASE 1: FALLACY ANALYSIS ===

Issue 1 of 3:
Location: wiki/development.md, Line 28
Fallacy Type: Self-Contradiction

Statement A: "This workflow requires all steps to be completed sequentially"
Statement B: "Steps can be parallelized for faster execution"

Problem: These statements directly contradict—steps cannot be both required to be sequential and parallelizable.

Options:
1. Update to clarify: "Steps are designed to be sequential by default, but can be parallelized for certain operations"
2. Remove sequential requirement: "Steps can be completed in parallel or sequentially depending on dependencies"
3. Remove parallelization claim: "All steps must be completed sequentially"

Your choice (1-3): _
```

After user selects (e.g., "1"), the skill updates the code and continues to the next issue.

```
Issue 2 of 3:
Location: wiki/setup.md, Line 1
Fallacy Type: False Attribution

Statement: "This wiki section explains how to install dependencies"

Problem: The section actually only covers environment setup, not dependency installation. Dependencies are covered in wiki/development.md.

Options:
1. Update description to: "This wiki section explains how to set up the development environment"
2. Move dependency installation content here from development.md
3. Leave as-is

Your choice (1-3): _
```

Once all phases complete:

```
=== REVIEW COMPLETE ===

Summary:
- Phase 1 (Fallacies): 3 issues found, 3 resolved
- Phase 2 (Contradictions): 3 issues found, 3 resolved
- Phase 3 (Inconsistencies): 4 issues found, 4 resolved

Total changes: 10 files updated

All issues have been addressed. Documentation is now consistent.
```

## When to Use This Skill

Use this skill when you want to:
- Audit project wiki documentation for logical errors
- Ensure wiki content is consistent and accurate
- Resolve conflicts between different wiki files
- Standardize documentation format across wiki files
- Prepare wiki for publication or review
- Verify cross-references within wiki are correct
- Align README.md with wiki structure and content

## Important Notes

- **Sequential Analysis**: Fallacies are fixed before contradictions are analyzed (fallacy fixes may resolve some contradictions)
- **Interactive Confirmation**: Each issue requires user approval unless `auto` mode is used
- **Code Updates Mid-Review**: Changes are applied after each issue resolution, allowing subsequent analyses to reflect previous fixes
- **Scope**: Reviews wiki/ directory and root README.md only. Excludes wiki/raw/ directory
- **Auto Mode**: When `auto` is specified, the skill uses heuristics to select the best available solution (prefers clarity, consistency, and minimal change)
- **Content Preservation**: All file content is preserved; only identified issues are modified
- **Integration**: Works well after `/cel.wiki.write` or `/cel.wiki.simplify` to ensure wiki is logically sound
- **Complementary**: Use after major wiki updates to verify consistency across all documentation files

## Example Use Cases

**Scenario 1: Reviewing Updated Wiki**
```
User: /cel.wiki.review
- Wiki documentation is reviewed for all issues
- User approves fixes interactively
- Wiki is ready for publication
```

**Scenario 2: Batch Fixing Wiki Issues**
```
User: /cel.wiki.review auto
- All wiki files are analyzed and fixed automatically
- Summary report provided
- No user intervention needed
```

**Scenario 3: Fallacy-Only Audit**
```
User: /cel.wiki.review fallacies
- Logical errors in wiki identified and presented
- User corrects issues interactively
- Contradictions and inconsistencies left for separate review
```

## Implementation Rules

- **Best Solution Selection** (Auto Mode):
  - Prefer explicit clarity over implicit assumptions
  - Choose solutions that reduce ambiguity
  - Prefer minimal, surgical changes
  - Avoid over-engineering solutions
  
- **Interactive Mode**:
  - Present 2-3 clear options per issue
  - Show exact quoted text from documentation
  - Include line numbers and file paths
  - Wait for explicit user response before proceeding
  
- **Change Logging**:
  - Track all changes made during review
  - Provide file-level summary at end
  - Allow user to review all changes before final commit
