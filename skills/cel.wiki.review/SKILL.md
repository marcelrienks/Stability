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

## Important Notes

- **Sequential Analysis**: Fallacies are fixed before contradictions are analyzed (fallacy fixes may resolve some contradictions)
- **Interactive Confirmation**: Each issue requires user approval unless `auto` mode is used
 - **Full-file reads required**: When reading any documentation file as part of wiki workflows, the agent MUST read the entire file contents (not just the first lines or a snippet) to obtain full contextual understanding before making decisions.
- **Code Updates Mid-Review**: Changes are applied after each issue resolution, allowing subsequent analyses to reflect previous fixes
- **Scope**: Reviews wiki/ directory and root README.md only. Excludes wiki/raw/ directory
- **Auto Mode**: When `auto` is specified, the skill uses heuristics to select the best available solution (prefers clarity, consistency, and minimal change)
- **Content Preservation**: All file content is preserved; only identified issues are modified
- **Integration**: Works well after `/cel.wiki.write` or `/cel.wiki.simplify` to ensure wiki is logically sound
- **Complementary**: Use after major wiki updates to verify consistency across all documentation files

## Interactive Q&A Standard

This skill uses a concise interactive Q&A pattern for all user-driven review decisions. Use this section as the canonical format for presenting issues and collecting user choices.

- **Overall pattern:** Present issues grouped or one-by-one with 2–3 clear resolution options; expect the user to reply with compact choice codes (e.g., `1A, 2B, 3C` or `auto`).
- **Per-item structure:**
  - **Issue header:** short label (e.g., "Issue 1 — False attribution").
  - **Location / context:** file reference and brief quoted text or location.
  - **Why:** one-line explanation of the problem/impact.
  - **Options:** 2–3 labeled choices (`A`, `B`, `C`) with concise outcomes and trade-offs.
  - **Selection prompt:** explicit instruction how to reply (example: `1A, 2C, 3B` or `auto`).
  - **Next step note:** what the assistant will do after the choice (apply patch, ask follow-up, etc.).
- **Reply format expected from user:** compact list of choice codes (e.g., `1A, 2B, 3C`) or the single word `auto`.
- **Defaults & automation:** The assistant may propose a default used when the user replies `auto` (heuristic: clarity-first, minimal changes) and documents it.
- **Preambles & actions:** Before making edits, the assistant gives a 1–2 sentence preamble describing the upcoming automated actions. After edits, the assistant summarizes files changed and updates the review status.
- **Meta conventions:** Preserve content when possible, prefer surgical edits, require explicit approval unless `auto`/`force` is specified, and log all changes for review.

Include this standard in every interactive prompt the skill generates unless the user explicitly requests a different interaction style.

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
