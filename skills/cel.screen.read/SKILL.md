---
name: cel.screen.read
description: "Analyzes the latest screenshot and answers questions about it in the context of your current session. Usage: `/cel.screen.read`"
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

## Important Notes

- **Platform detection first**: The skill identifies your OS, then locates the appropriate screenshot directory
- **Supported formats**: PNG, JPEG, and GIF
- **Time-based filtering**: Only considers screenshots modified within the last 2 minutes for recency
- **Clipboard fallback**: Automatically checks system clipboard if no recent file is found
- **Session context**: Analysis respects your current debugging or development task
- **Autonomous execution**: Multi-step platform detection and directory navigation happen automatically without permission prompts
