---
name: cel.screen.read
description: Analyzes the latest screenshot from the Windows Screenshots directory (accessible via WSL) and answers questions about it in the context of the current session.
---

# Review Screenshot

This skill automatically finds and analyzes the most recent screenshot from your system's default screenshots directory, helping you review and understand visual content within the context of your current work.

## What This Skill Does

When you invoke this skill, it will:

1. **Detect your platform** (Windows, WSL, Linux, or macOS)
2. **Locate the latest screenshot** from the appropriate directory for your platform
3. **Load and analyze the image** to understand its visual content
4. **Answer questions about the screenshot** in the context of your current session
5. **Provide insights** about what's shown in the image

## How to Use This Skill

### Option 1: Using the Slash Command
```
/cel.screen.read
```

### Option 2: Calling as a Named Skill
```
skill: "cel.screen.read"
```

After invoking the skill, you can then ask questions about the screenshot, such as:
- "What's shown in this screenshot?"
- "Can you find the button labeled X?"
- "What errors or warnings are visible?"
- "Describe what you see in detail"

## Workflow

The skill executes the following process:

1. **Detect Platform**: Identifies the operating system (Windows, macOS, or Linux/WSL)
2. **Locate Latest Screenshot**: Finds the most recent screenshot (file or clipboard) from the platform-specific directory, or falls back to clipboard if not found
3. **Analyze Content**: Examines the image in the context of your current debugging session. The agent provides detailed analysis such as:
   - Error messages or stack traces visible
   - State of your code editor or terminal
   - UI elements, logs, or diagnostics relevant to your current work
   - Visual confirmation of expected vs. actual behavior
   - Recommendations based on what's visible and your session activity

## Platform-Specific Details

| Platform | Default Location(s) | Clipboard Fallback |
|----------|---------------------|--------------------|
| **macOS** | `~/Documents`, `~/Desktop` | `pbpaste` |
| **Windows** | `%USERPROFILE%\Pictures\Screenshots` | `Get-ClipboardImage` |
| **Linux/WSL** | `/mnt/c/Users/<username>/Pictures/Screenshots` or `~/Pictures/Screenshots` | `xclip` / `xsel` |

The skill searches each location for images modified within the last 2 minutes. If no recent file is found, it checks the system clipboard.

## Use Case: Debugging in Agent Sessions

This skill is designed to streamline debugging workflows when working with agents in the command line or VS Code:

1. **Take a screenshot** during your development session when you encounter an issue, error, or unexpected behavior
2. **Invoke the skill** with `/cel.screen.read` while talking to the agent
3. **The agent analyzes** the visual output (errors, terminal state, UI, logs, etc.) in the context of your current debugging task
4. **Get detailed insights** about what's happening, combining visual information with knowledge of your session activity
5. **Accelerate troubleshooting** by having the agent understand both code-level context and visual debugging information

## When to Use This Skill

Use this skill when you want to:
- Review the latest screenshot quickly without manual file navigation
- Get AI analysis of what's shown in your screenshots during debugging
- Ask questions about visual content (errors, terminal output, UI state) in context
- Troubleshoot issues by providing visual evidence to the agent
- Document or discuss what's displayed on your screen to the agent for better assistance

## Example Interactions

**Debugging an error:**
```
User: /cel.screen.read
User: What error messages are visible?

Copilot:
Locates the latest screenshot, analyzes it, identifies stack traces or error messages, and provides context for debugging.
```

**Reviewing terminal output:**
```
User: /cel.screen.read
User: Can you read the terminal output?

Copilot:
Finds the screenshot, reads terminal output, identifies warnings or failures, and connects them to your current session work.
```

If no screenshot is found in the designated directory or clipboard, the skill will state this clearly.

## Important Notes

- **Platform detection first**: The skill identifies your OS, then locates the appropriate screenshot directory
- **Supported formats**: PNG, JPEG, and GIF
- **Time-based filtering**: Only considers screenshots modified within the last 2 minutes for recency
- **Clipboard fallback**: Automatically checks system clipboard if no recent file is found
- **Session context**: Analysis respects your current debugging or development task
- **Autonomous execution**: Multi-step platform detection and directory navigation happen automatically without permission prompts
