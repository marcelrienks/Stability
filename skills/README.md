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
- `cel.src.review` - Source code review skill
- `cel.wiki.init` - Wiki initialization
- `cel.wiki.read` - Wiki reading
- `cel.wiki.simplify` - Wiki simplification
- `cel.wiki.write` - Wiki writing
