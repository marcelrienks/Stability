---
name: cel.git.sync
description: Automates git workflow with staged changes, intelligent commit messages, pull with merge conflict resolution, and push to remote. Use this skill when you need to perform a complete git synchronization workflow.
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

## How to Use This Skill

### Option 1: Using the Slash Command
```
/git sync
```

### Option 2: Calling as a Named Skill
```
skill: "git sync"
```

## When to Use This Skill

Use the Custom Git Sync skill when you need to:
- Quickly synchronize your local work with the remote repository
- Automatically stage, commit, and push changes in one workflow
- Handle merge conflicts that arise during pulls
- Generate meaningful commit messages without manual input

## Example Workflow

```
User: "Run custom git sync"
Copilot: 
1. Stages all changes with git add .
2. Reviews staged changes and creates a commit message
3. Pulls from remote, handling any merge conflicts
4. Pushes the synchronized work to remote
```

## Important Notes

- The skill requires an active git repository in the current working directory
- The user must have appropriate permissions on the remote repository to push changes
- The current branch must be tracking a remote branch for pull and push to work correctly
- During conflict resolution, manual review may be needed for complex conflicts
- This skill executes all steps autonomously without asking for permission - this is intentional behavior designed for skill workflows
- The skill will automatically handle multi-step operations across different git states and directories without interruption
