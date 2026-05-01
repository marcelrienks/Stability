---
name: cel.read-docs
description: Usage: /cel.read-docs [refresh] Analyse docs and persist a context map, preventing redundant reading.
---

# Read and Persist Project Context

This skill performs a complete analysis of project documentation, distilling it into a persistent context file that the agent reuses to maintain state across interactions.

## Workflow Steps

### 1. Check for Existing Context
Before scanning, check for `.cel/context.md`.
- If missing: Proceed to full scan.
- If exists: Compare stored doc hashes against current `.md` files.
  - If `refresh` argument passed: Skip hash check, force full rescan.
  - If hashes match: Read context, skip rescan.
  - If hashes differ: Proceed to full scan (docs updated).

### 2. Deep Ingestion (Recursive Search)
Search the root and all subdirectories for:
- **Primary:** `README.md` (and common variants like `.txt` or `.markdown`).
- **Secondary:** All `.md` files throughout the directory tree.
- **Linked Assets:** Only follow links to diagrams (`.mmd`, `.svg`), images, or referenced `.txt` files.
- **Exclusions:** Dot-prefixed directories (`.specify`, `.cel`, `.github`), `specs/` directory, and `node_modules/`

### 3. Context Distillation (Intelligence Phase)
Instead of just holding raw text, process the findings into the following categories:
- **Project Purpose:** The "What" and "Why" of the codebase.
- **Architecture & Tech Stack:** Identified languages, frameworks, and structural patterns.
- **Key Workflows:** Critical paths or logic flows found in diagrams and docs.
- **Documentation Map:** A directory of where specific information lives (e.g., "API specs found in /docs/api").

### 4. Persistence (Writing Memory)
Generate or update a hidden file at `.cel/context.md`. 
- Format this file as a "Technical Brief" optimized for LLM consumption.
- Include a timestamp of the last "Deep Read."
- Store MD5 hashes of all scanned `.md` files (for future change detection).
- **Note:** This file serves as the agent's "state" for future requests.

### 5. Simple Output
Provide the user with a concise 2-3 sentence confirmation of the project's nature and a notification that the project context has been persisted for improved performance.

## How to Use This Skill

### Option 1: Initial Ingest
```
/cel.read-docs
```

### Option 2: Auto-Smart (Default)
Context loaded if hashes match docs. Auto-rescan if docs changed.
```
/cel.read-docs
```

### Option 3: Force Refresh
Override hash check, always rescan and update context.
```
/cel.read-docs refresh
```

## Important Notes

- **Efficiency First**: Goal is move "Reading" → "Knowing." Reuse cached context if hash match.
- **Auto-Detection**: Hash check automatic. If docs change, rescan triggered without manual refresh.
- **Force Override**: Use `/cel.read-docs refresh` to skip hash check and force full rescan (useful after major doc restructure).
- **No Code Bloat**: Read docs only, not source code (unless explicitly linked).
- **Silent Update**: `.cel/` directory and context file created automatically.
- **Mermaid Support**: Interpret diagrams into "Key Workflows" section of persistent context.
