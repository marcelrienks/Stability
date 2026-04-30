---
name: cel.read-docs
description: Analyzes project documentation to build and persist a high-utility context map, preventing redundant reading in future sessions.
---

# Read and Persist Project Context

This skill performs a complete analysis of project documentation, distilling it into a persistent context file that the agent reuses to maintain state across interactions.

## Workflow Steps

### 1. Check for Existing Context
Before scanning, search the root directory for `.cel/context.md`.
- If found: Read this file immediately to establish baseline context.
- If missing or outdated: Proceed to full scan.

### 2. Deep Ingestion (Recursive Search)
Search the root and all subdirectories for:
- **Primary:** `README.md` (and common variants like `.txt` or `.markdown`).
- **Secondary:** All `.md` files throughout the directory tree.
- **Linked Assets:** Only follow links to diagrams (`.mmd`, `.svg`), images, or referenced `.txt` files.

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
- **Note:** This file serves as the agent's "state" for future requests.

### 5. Simple Output
Provide the user with a concise 2-3 sentence confirmation of the project's nature and a notification that the project context has been persisted for improved performance.

## How to Use This Skill

### Option 1: Initial Ingest
```
/read docs
```

### Option 2: Refresh Memory (Use when docs change)
```
skill: "read docs" force_refresh: true
```

## Important Notes

- **Efficiency First**: The goal is to move from "Reading" to "Knowing." Avoid re-reading raw files if the `context.md` is sufficient for the user's query.
- **No Code Bloat**: Do NOT read source code or config files unless they are explicitly linked as documentation.
- **Silent Update**: The creation of the `.cel/` directory and context file should be handled automatically as part of the skill execution.
- **Mermaid Support**: Ensure all mermaid diagrams are interpreted into the "Key Workflows" section of the persistent context.
