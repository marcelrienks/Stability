---
name: cel.read-scr-sht
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
/cel.read-scr-sht
```

### Option 2: Calling as a Named Skill
```
skill: "cel.read-scr-sht"
```

After invoking the skill, you can then ask questions about the screenshot, such as:
- "What's shown in this screenshot?"
- "Can you find the button labeled X?"
- "What errors or warnings are visible?"
- "Describe what you see in detail"

## Workflow

The skill executes the following process:

1. **Detect Platform**: Identifies the operating system (Windows, macOS, or Linux/WSL)
2. **Locate Screenshot Directory**: Based on the detected platform, checks the default screenshot location
3. **Filter Recent Files**: Scans the detected directory for image files (PNG, JPEG, or GIF) modified within the last 2 minutes
4. **Select Latest**: Identifies the most recently modified image file from the filtered results
5. **Fallback to Clipboard**: If no recent file is found, checks the system clipboard for a currently stored image
6. **Load Image**: Loads the selected screenshot (from file or clipboard) into memory
7. **Analyze Content**: Examines the image to understand its visual elements
8. **Answer Questions**: Analyzes the screenshot in the context of your current debugging or development session. The agent understands what task you're working on and provides detailed analysis such as:
   - Error messages or stack traces visible
   - State of your code editor or terminal
   - UI elements, logs, or diagnostics relevant to your current work
   - Visual confirmation of expected vs. actual behavior
   - Recommendations based on what's visible in the screenshot and your current session activity

## Platform-Specific Details

### Windows
- **Default Location**: `%USERPROFILE%\Pictures\Screenshots`
- **Workflow**: 
  1. Detect Windows OS
  2. Access the Screenshots folder in the user's Pictures directory
  3. Search for files modified within the last 2 minutes
  4. If no file found, check Windows clipboard for an image using `Get-ClipboardImage`
  5. Load and analyze the most recent file or clipboard image

### macOS
- **Default Locations** (checked in order): `~/Documents`, `~/Desktop`
- **Workflow**:
  1. Detect macOS OS
  2. Check Documents folder for recent screenshots
  3. If not found, check Desktop folder
  4. Search for files modified within the last 2 minutes
  5. If no file found, check macOS clipboard for an image using `pbpaste`
  6. Load and analyze the most recent file or clipboard image

### Linux/WSL
- **Default Locations** (checked in order):
  1. `/mnt/c/Users/<username>/Pictures/Screenshots` (Windows drive via WSL mount)
  2. `~/Pictures/Screenshots` (native Linux location)
- **Workflow**:
  1. Detect Linux/WSL environment
  2. Attempt to access Windows Screenshots directory through the `/mnt/c/` mount point
  3. If not found, fall back to native Linux screenshot directory
  4. Search for files modified within the last 2 minutes
  5. If no file found, check system clipboard for an image using `xclip` or `xsel`
  6. Load and analyze the most recent file or clipboard image

## Use Case: Debugging in Agent Sessions

This skill is designed to streamline debugging workflows when working with agents in the command line or VS Code:

1. **Take a screenshot** during your development session when you encounter an issue, error, or unexpected behavior
2. **Invoke the skill** with `/cel.read-scr-sht` while talking to the agent
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

## Example Interaction

```
User: /cel.read-scr-sht
User: What error messages are visible?

Copilot:
1. Locates the latest screenshot from your Screenshots folder
2. Loads and analyzes the image
3. Identifies any error messages visible in the screenshot
4. Describes the errors and their context
```

If no screenshot is found in the designated directory, the skill will state this clearly in its response.

## Important Notes

- The skill **first detects the platform** (Windows, macOS, or Linux/WSL), then executes the appropriate platform-specific workflow
- **Supported formats**: PNG, JPEG, and GIF (the most commonly used formats across all OS platforms)
- **Time-based filtering**: Only considers screenshots modified within the **last 2 minutes** to ensure recent captures
- **Clipboard Fallback**: If no recent file is found in the filesystem, the skill automatically checks the system clipboard for an image:
  - **Windows**: Uses `Get-ClipboardImage` (available on Windows 10+)
  - **macOS**: Uses `pbpaste` command
  - **Linux/WSL**: Uses `xclip` or `xsel` (if installed)
- For **WSL**: Attempts to access Windows screenshot directories through the `/mnt/c/` mount point, with fallback to native Linux locations
- For **macOS**: Checks configured default locations (Documents and Desktop) in priority order
- For **Windows**: Uses the standard user Pictures\Screenshots directory
- If no screenshot is found in the filesystem or clipboard, the skill will state this clearly in its response
- The analysis respects your current session context when answering questions
- **Autonomous execution**: This skill executes all multi-step platform detection and directory navigation steps automatically without asking for permission - this is intentional behavior designed for skill workflows
