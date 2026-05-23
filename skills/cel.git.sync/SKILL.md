---
name: cel.git.sync
description: "Automates git workflow with staged changes, intelligent commit messages, pull with merge conflict resolution, and push to remote. Usage: `/cel.git.sync`"
---

# Git Sync

This skill performs a complete git synchronization workflow with intelligent change summarization and conflict resolution.

## Workflow Steps

The Custom Git Sync skill executes the following steps in order:

### 1. Stage All Untracked Changes
Execute `git add .` to stage all untracked and modified changes.

### 2. Generate Summary and Commit
Before committing, analyze the staged changes using `git diff --cached` or `git diff --cached --stat` to understand what was changed. Generate a concise, meaningful commit message that summarizes all the changes made, then execute `git commit -m "message"` with your generated message.

The commit message should:
- Be concise but descriptive
- Summarize the key changes made
- Start with a capitalized action verb when possible
- Use present tense

Example commit messages:
- "Add user authentication module"
- "Fix database connection timeout issue"
- "Update API documentation and examples"
- "Refactor utility functions for better performance"

### 3. Pull from Remote with Merge
Execute `git pull origin <current-branch>` to fetch and merge the latest changes from the remote repository.

### 4. Handle Merge Conflicts
If merge conflicts occur during the pull:
- Use `git status` to identify conflicted files
- For each conflicted file, review the conflict markers to understand the conflict
- Resolve conflicts: prefer remote changes (assume authoritative); if both are equally valid, merge manually to preserve both
- Use `git add <file>` to mark conflicts as resolved
- Complete the merge with `git commit` (no message needed for merge commits)

### 5. Push to Remote
Once the merge is complete, execute `git push origin <current-branch>` to push the synchronized changes to the remote repository.

## Important Notes

- The skill requires an active git repository in the current working directory
- The user must have appropriate permissions on the remote repository to push changes
- The current branch must be tracking a remote branch for pull and push to work correctly
 - The current branch must be tracking a remote branch for pull and push to work correctly
 - The skill performs multi-step git operations only when explicitly triggered by the user; during that triggered run it may perform subsequent steps without further prompts, but it will never schedule or initiate autonomous git operations in the future
 - The skill will handle the steps of a triggered operation across multiple git states and directories during that run, but it does not and will not initiate additional runs on its own

## Autonomy Boundary — Critical for Agent Behavior

⚠️ **This skill is strictly user-initiated. Do NOT interpret successful execution as permission for autonomous git operations.**

### What the Agent MUST NOT Do

- **Do NOT automatically run this skill** after file edits, code generation, or any other operations
- **Do NOT assume permission** to perform git operations (add, commit, pull, push) without explicit user instruction
- **Do NOT interpret** the user running this skill once as blanket authorization for future git operations
- **Do NOT bundle** git operations into other workflows without explicit user consent
- **Do NOT perform ANY git functionality autonomously** unless the user expressly states and instructs it for that specific situation

### User Intent Required Each Time

Every execution of this skill requires an explicit trigger from the user:
- The user must say "run git sync", "sync changes", `/cel.git.sync`, or similar direct request
- Each git operation must be intentional and user-initiated
- The agent should never assume the user wants git operations to happen automatically

### Example of Correct Behavior

❌ **WRONG**: User runs `/cel.git.sync` → Agent then automatically runs git sync after every code edit going forward  
✓ **CORRECT**: User runs `/cel.git.sync` → Agent executes the workflow → Agent waits for the next explicit user request to run git operations again
