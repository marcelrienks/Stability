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
| **macOS** | `~/Documents`, `~/Desktop` | `pngpaste` (requires installation) |
| **Windows** | `%USERPROFILE%\Pictures\Screenshots` | `Get-ClipboardImage` |
| **Linux/WSL** | `/mnt/c/Users/<username>/Pictures/Screenshots` or `~/Pictures/Screenshots` | `xclip` / `xsel` |

The skill searches each location for images modified within the last 2 minutes. If no recent file is found, it checks the system clipboard for an image. On macOS, clipboard-image fallback requires a user-installed tool such as `pngpaste`; if that tool is not installed, clipboard fallback is disabled.

## Important Notes

- **Platform detection first**: The skill identifies your OS, then locates the appropriate screenshot directory
- **Supported formats**: PNG, JPEG, and GIF
- **Time-based filtering**: Only considers screenshots modified within the last 2 minutes for recency
- **Clipboard fallback**: Checks the system clipboard for an image when no recent screenshot file is found. On macOS this requires a user-installed tool such as `pngpaste`; if such a tool is not present, clipboard fallback is not available.
- **Session context**: Analysis respects your current debugging or development task
- **Automation during invoked runs**: During an explicit user invocation, the skill automates platform detection and directory/clipboard checks to locate screenshots; it does not initiate runs on its own.
