---
name: cel.wiki.read
description: "Analyze wiki and persist a context map, preventing redundant reading. Usage: `/cel.wiki.read [refresh]`"
---

# Read and Persist Project Context

This skill performs a complete analysis of project documentation, distilling it into a persistent context file that the agent reuses to maintain state across interactions.

## Workflow Steps

### 1. Check for Existing Context

1. If `.cel/context.md` missing → **proceed to Step 2** (full scan).
2. If exists:
   - `refresh` arg passed? → **Skip hash check, proceed to Step 2** (forced rescan).
   - Hashes match all `.md` files in the `wiki/` directory? → **HALT. Read context file only (Step 5 cache-hit output). Done.**
   - Hashes differ? → **Proceed to Step 2** (wiki updated, full scan).

### 2. Deep Ingestion (Recursive Search)
Search the root and all subdirectories for:
- **Primary:** `README.md` (and common variants like `.txt` or `.markdown`).
- **Secondary:** All `.md` files throughout the directory tree, including all subdirectories.
- **Linked Assets:** Only follow links to diagrams (`.mmd`, `.svg`), images, or referenced `.txt` files.
- **Exclusions (directory or file name matches):**
  - Dot-prefixed directories (`.specify`, `.cel`, `.github`)
  - `specs/`, `node_modules/`
  - Any directory or file whose name contains `archive`, `original`, `orig`, `backup`, or `bak` (case-insensitive, e.g. `docs_backup/`, `README.orig.md`)
  - Any directory associated with addons, plugins, or external libraries (e.g. `addons/`, `plugins/`, `vendor/`, `third_party/`, `external/`, `lib/`, `libs/`)
- **Project files only:** Only read `.md` files that are authored as part of this project. Do **not** read documentation bundled with dependencies, packages, or any externally sourced library.

### 3. Context Distillation (Intelligence Phase)
Instead of just holding raw text, process the findings into the following categories:
- **Project Purpose:** The "What" and "Why" of the codebase.
- **Architecture & Tech Stack:** Identified languages, frameworks, and structural patterns.
- **Key Workflows:** Critical paths or logic flows found in diagrams and docs.
- **Documentation Map:** A directory of where specific information lives (e.g., "API specs found in /wiki/api").

### 4. Persistence (Writing Memory)
Generate or update a hidden file at `.cel/context.md`. 
- **File naming rule:** The output file name MUST always be `context.md` (all lowercase). No other casing (e.g. `Context.md`, `CONTEXT.MD`) is permitted.
- Format this file as a "Technical Brief" optimized for LLM consumption.
- Include a timestamp of the last "Deep Read."
- Store MD5 hashes of:
  - All scanned `.md` files in the `wiki/` directory (excluding `wiki/raw/`)
  - The root `README.md` file
  - Use these hashes for future change detection (for future change detection).
- **Note:** This file serves as the agent's "state" for future requests.

### 5. Simple Output (Conditional)

**Cache Hit** (hashes match, no rescan):
Confirm context loaded from cache. Example: "Project context loaded from cache (last read: [DATE]). Ready."

**Cache Miss or Docs Changed** (rescan performed):
Confirm new write. Example: "Project analyzed. Context persisted with hashes. Ready."

**Refresh** (forced rescan via `refresh` arg):
Confirm override. Example: "Forced refresh: project re-scanned, context updated. Ready."

All outputs: concise 2-3 sentences confirming project nature and cache/scan status.

## Important Notes

- **Efficiency First**: Goal is move "Reading" → "Knowing." Reuse cached context if hash match.
 - **Full-file reads required**: When reading any documentation file as part of wiki workflows, the agent MUST read the entire file contents (not just the first lines or a snippet) to obtain full contextual understanding before making decisions.
- **Auto-Detection**: Hash check automatic. If wiki changes, rescan triggered without manual refresh.
- **Force Override**: Use `/cel.wiki.read refresh` to skip hash check and force full rescan (useful after major wiki restructure).
- **No Code Bloat**: Read wiki only, not source code (unless explicitly linked).
- **Silent Update**: `.cel/` directory and context file created automatically.
- **Mermaid Support**: Interpret diagrams into "Key Workflows" section of persistent context.
