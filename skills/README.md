# Skills Deployment

This directory contains Copilot skills that can be deployed to your local environment.

## Deployment

To deploy the skills, make the script executable and run it:

```bash
chmod +x deploy-cel-skills.sh
./deploy-cel-skills.sh
```

Alternatively, you can run it directly with bash:

```bash
bash deploy-cel-skills.sh
```

The script auto-detects your platform and deploys skills to `~/.agents/skills`.

## Skills

- `cel.git.sync` - Git synchronization skill
- `cel.screen.read` - Screen reading capability
- `cel.screen.read` - Screen reading capability
- `cel.wiki.init` - Wiki initialization
- `cel.wiki.read` - Wiki reading
- `cel.wiki.simplify` - Wiki simplification
- `cel.wiki.write` - Wiki writing

## Autonomy Policy

- **Principle**: No skill will initiate or schedule its own runs without an explicit user invocation. All skills require a user trigger (command, API call, or explicit action) to start.
- **Triggered Runs**: During a single user-triggered run, a skill may perform multiple automated steps (detection, scanning, file movement, or resolution) to complete its workflow. Those internal automations happen within the context of that triggered run and do not imply permission for future autonomous executions.
- **Per-skill Notes:**
	- `cel.git.sync`: Executes only when explicitly invoked; may perform multi-step git operations during that run but will never run git operations autonomously afterward.
	- `cel.screen.read`: Automates platform detection and directory/clipboard checks during an invocation to locate recent screenshots; it does not initiate runs by itself and may require third-party tooling (noted in its skill doc).
	- `cel.wiki.read` / `cel.wiki.init` / `cel.wiki.simplify` / `cel.wiki.write`: Perform analyses and file operations only when invoked; `cel.wiki.read` uses hash checks as part of its run to decide whether a deeper scan is needed, but it does not start scans without being triggered.

If you prefer a stricter policy (no internal automation even during a triggered run), say so and I will update all skill docs to reflect that preference.
