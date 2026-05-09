---
name: cel.wiki.init
description: "Initialize and organize project wiki with wiki/raw folder structure at project root. Usage: `/cel.wiki.init`"
---

# Initialize & Organize Project Documentation

This skill provides a one-time setup to discover, organize, and index all documentation in a project. It creates a standardized folder structure with `wiki/` (for all wiki content) and `wiki/raw/` (for static assets) at the project root, consolidates scattered wiki content from across the codebase, removes obsolete folder structures, and generates a persistent context map for reuse.

## Workflow Steps

### 1. Create Folder Structure
If not already present, create the following directory structure at the project root:
```
root/
  wiki/
    raw/       (static assets: PDFs, transcripts, exports, etc)
```
Note: Both `wiki/` and `wiki/raw/` must exist in the root directory.

### 2. Discover & Move Markdown Documentation
Recursively search the entire codebase for all `.md` files (except in excluded directories/files):

**Inclusions:**
- All `.md` files from any directory

**Exclusions (do NOT include):**
- `README.md` at project root (must remain in root)
- Dot-prefixed directories (`.github/`, `.cel/`, `.git/`, `.vscode/`, etc.)
- Package/dependency directories: `node_modules/`, `vendor/`, `lib/`, `libs/`, `.venv/`, `venv/`, etc.
- Archive/backup directories: `archive/`, `backup/`, `bak/`, any directory with `archive`, `backup`, `orig`, `bak` in the name (case-insensitive)
- External library docs: `addons/`, `plugins/`, `third_party/`, `external/`
- Large generated directories: `dist/`, `build/`, `.next/`, `out/`

**Action:**
- Move all discovered `.md` files to `wiki/` in a flat structure (do not preserve original directory structure)
- PRESERVE `README.md` at project root (do NOT move it)
- Example: `src/docs/guide.md` → `wiki/guide.md`, `docs/api.md` → `wiki/api.md`, but `README.md` stays at root

### 3. Discover & Move Static Documentation
Search the codebase for static/immutable documentation assets:

**Include file types:**
- `.pdf` - PDF documents and reports
- `.txt` - Text files (meeting notes, transcripts)
- `.docx`, `.doc` - Word documents
- `.xlsx`, `.xls` - Spreadsheets (exported data, research)
- `.pptx`, `.ppt` - Presentations
- Video transcripts (files with `transcript`, `captions`, `srt` in the name)
- YouTube transcripts (`.vtt`, `.srt`, `.txt` in a `transcripts/` subdirectory)
- Markdown exports of web articles (files in `exports/`, `clipped/`, or similar with metadata)
- Code repository exports/archives (`.tar.gz`, `.zip` of external repos in a `repos/` subdirectory)

**Exclusions:**
- Same directory exclusions as Step 2
- Binary files in node_modules, venv, or package directories
- Generated/compiled assets (`.o`, `.pyc`, `.dll`, etc.)

**Action:**
- Move all discovered static assets to `wiki/raw/`
- Organize by type (wiki/raw/PDFs/, wiki/raw/Transcripts/, wiki/raw/Exports/, etc.)
- Preserve original metadata/filenames

### 4. Clean Up Empty Directories
After moving all documentation, remove any empty directories:

**Target directories:**
- `docs/` (if empty)
- Any directory named `orig/` (if empty)
- Any directory named `archive/` (if empty after doc moves)

**Action:**
- Only remove if directory is completely empty
- Do NOT remove if it contains non-documentation files
- Preserve any folders that still contain code or other project files

### 5. Generate Persistent Context
After all files are organized:
- Invoke the `/cel.wiki.read` skill
- This will create `.cel/context.md` with project analysis, hashes, and a persistent context map
- Prevents redundant reading on future interactions

## How to Use This Skill

### Option 1: Slash Command
```
/cel.wiki.init
```

### Option 2: Named Skill
```
skill: "cel.wiki.init"
```

This single command will:
1. Create the wiki/ and wiki/raw/ directory structure at project root
2. Discover all .md files (except README.md at root) and move them to wiki/
3. Preserve README.md in the project root
4. Discover all static docs and move them to wiki/raw/
5. Remove any empty docs/ or orig/ folders
6. Generate a persistent context map via cel.wiki.read

## Output & Reporting

After completion, the skill will provide:

1. **Structure Created**: Confirm wiki/ and wiki/raw/ folders are in place at project root
2. **Files Moved**:
   - Summary of .md files discovered and moved to wiki/ (with counts)
   - Confirmation that README.md remained in project root
   - Summary of static assets moved to raw/ (with counts and types)
3. **Cleanup Summary**: List of empty directories removed
4. **Context Status**: Confirm context map generated at .cel/context.md
5. **Next Steps**: Suggest running `/cel.wiki.simplify` to audit and consolidate redundant content

## Important Notes

- **One-Time Operation**: This skill is designed to run once to establish the wiki structure. After that, manually place new wiki content in wiki/ or wiki/raw/ as appropriate.
- **Preservation**: All file content is preserved during moves; only location changes.
- **Audit Trail**: Keep track of what was moved for verification.
- **Non-Destructive**: Only removes truly empty directories; preserves all documentation.
- **Integration**: Works as a prerequisite for `/cel.docs.read` and `/cel.docs.simplify` skills.
- **Exclusions Matter**: Carefully exclude package directories and archives to avoid moving dependencies or backups into the wiki structure.

## Workflow Integration

Typical wiki management workflow:
1. **First Run**: `/cel.wiki.init` - Organize scattered documentation
2. **Review**: `/cel.wiki.simplify` - Audit and consolidate redundancies
3. **Ongoing**: `/cel.wiki.read` (or `refresh`) - Keep context map updated
