---
name: cel.src.review
description: "Review source code documentation for fallacies, contradictions, and inconsistencies. Usage: `/cel.src.review [auto]`"
---

# Source Code Review

This skill performs a comprehensive three-phase review of source code documentation (skill documentation, markdown files, code comments, etc.), systematically identifying and resolving fallacies, contradictions, and inconsistencies.

## Workflow Steps

### Phase 1: Fallacy Analysis
Identifies logical fallacies and unsupported claims in documentation:

**Detects:**
- Appeal to authority (assuming something is correct because authority says so)
- Self-contradictions (claiming both X and not-X)
- False attribution (claiming features that are delegated to other components)
- Vague scope ambiguity (unclear what is actually being reviewed/analyzed)
- Unsupported assumptions (stating facts without evidence)
- Hasty generalizations (broad claims based on limited cases)

**Interactive Process (unless `auto` mode):**
1. Identify and state each fallacy clearly with location and context
2. Explain why it's a fallacy
3. Present optional solutions for the user to choose from
4. Update codebase based on user selection
5. Move to next fallacy

### Phase 2: Contradiction Analysis
Identifies direct conflicts between statements within documentation:

**Detects:**
- Command mismatches (documentation says `/command1` but skill name suggests `/command2`)
- Feature contradictions (skill claims both autonomous execution and requires manual intervention)
- Conflicting requirements (Step A requires X, Step B forbids X)
- Scope conflicts (same feature described with different boundaries)

**Interactive Process (unless `auto` mode):**
1. State each contradiction with both conflicting statements quoted
2. Explain the conflict and its impact
3. Present resolution options
4. Update codebase based on user selection
5. Move to next contradiction

### Phase 3: Inconsistency Analysis
Identifies inconsistencies in naming, format, terminology, and structure:

**Detects:**
- Skill name vs folder name mismatches
- Description format inconsistencies (using different styles across skills)
- Parameter naming inconsistencies
- Cross-skill reference errors
- YAML frontmatter format variations

**Interactive Process (unless `auto` mode):**
1. Identify inconsistency and show the variants
2. Explain the impact (user confusion, invocation failures, etc.)
3. Present standardization options
4. Update codebase based on user selection
5. Move to next inconsistency

## How to Use This Skill

### Option 1: Slash Command
```
/cel.src.review                        # All phases, interactive mode (default)
/cel.src.review auto                   # All phases, auto-fix mode
/cel.src.review fallacies              # Fallacy analysis only, interactive
/cel.src.review contradictions         # Contradiction analysis only, interactive
/cel.src.review inconsistencies        # Inconsistency analysis only, interactive
/cel.src.review fallacies auto         # Fallacy analysis only, auto-fix
/cel.src.review contradictions auto    # Contradiction analysis only, auto-fix
/cel.src.review inconsistencies auto   # Inconsistency analysis only, auto-fix
```

### Option 2: Named Skill
```
skill: "cel.src.review"
skill: "cel.src.review auto"
skill: "cel.src.review fallacies"
```

## Workflow Example

**User Input:**
```
/cel.src.review
```

**Copilot Response:**

```
Starting source code documentation review...

=== PHASE 1: FALLACY ANALYSIS ===

Issue 1 of 3:
Location: skills/cel.git.sync/SKILL.md, Line 63
Fallacy Type: Self-Contradiction

Statement A: "This skill executes all steps autonomously without asking for permission"
Statement B: "During conflict resolution, manual review may be needed for complex conflicts"

Problem: These statements directly contradict—a skill cannot be fully autonomous if manual intervention is sometimes required.

Options:
1. Update to clarify: "Attempts autonomously, but manual intervention may be required for complex conflicts"
2. Remove autonomous claim entirely: "Executes steps in sequence, with manual intervention for complex conflicts"
3. Remove manual requirement claim: "Executes all steps autonomously, complex conflicts handled automatically"

Your choice (1-3): _
```

After user selects (e.g., "1"), the skill updates the code and continues to the next issue.

```
Issue 2 of 3:
Location: skills/cel.wiki.init/SKILL.md, Line 1
Fallacy Type: False Attribution

...

Options:
1. Update description to: "uses cel.wiki.read to persist context"
2. Move context generation to this skill (complex change)
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
- Audit source code documentation for logical errors
- Ensure skill documentation is consistent and accurate
- Resolve conflicts between documentation and actual implementation
- Standardize documentation across multiple files
- Prepare documentation for publication or review
- Verify that all cross-references are correct

## Important Notes

- **Sequential Analysis**: Fallacies are fixed before contradictions are analyzed (fallacie fixes may resolve some contradictions)
- **Interactive Confirmation**: Each issue requires user approval unless `auto` mode is used
- **Code Updates Mid-Review**: Changes are applied after each issue resolution, allowing subsequent analyses to reflect previous fixes
- **Scope**: Reviews skill documentation, README files, markdown documentation, and YAML frontmatter by default
- **Auto Mode**: When `auto` is specified, the skill uses heuristics to select the best available solution (prefers clarity, consistency, and minimal change)
- **Context Preservation**: All file content is preserved; only identified issues are modified
- **Integration**: Works well after documentation creation or major documentation refactoring
- **Complementary**: Use after `/cel.wiki.simplify` to ensure simplified wiki is also logically sound

## Example Use Cases

**Scenario 1: Reviewing New Skills**
```
User: /cel.src.review
- New skill documentation is reviewed for all issues
- User approves fixes interactively
- Skill is ready for deployment
```

**Scenario 2: Batch Fixing Multiple Skills**
```
User: /cel.src.review auto
- All skills are analyzed and fixed automatically
- Summary report provided
- No user intervention needed
```

**Scenario 3: Fallacy-Only Audit**
```
User: /cel.src.review fallacies
- Logical errors identified and presented
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
