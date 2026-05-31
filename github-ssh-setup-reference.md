# GitHub SSH setup reference

## Overview

This document describes how to setup 2 ssh agents (Bitwarden, 1Password), each with different github accounts, on 1 machine seemlessly:

- **Bitwarden SSH agent** for personal GitHub access
- **1Password SSH agent** for corporate GitHub access

Because these use different agent sockets, SSH cannot automatically try both agents for a single `github.com` connection. The solution is:

1. Define separate SSH host aliases in `~/.ssh/config`
2. Keep each alias bound to a specific agent socket
3. Use global Git URL rewrite rules so standard GitHub SSH URLs are automatically redirected to the correct alias

This avoids having to manually edit clone URLs.

## Current SSH config

File: `~/.ssh/config`

```ssh-config
Host github-personal
    HostName github.com
    User git
    IdentityAgent /Users/marcel.rienks/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
    IdentitiesOnly no

Host github-corp
    HostName github.com
    User git
    IdentityAgent "/Users/marcel.rienks/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    IdentitiesOnly no
```

## What each alias currently authenticates as

- `github-personal` -> GitHub user **`marcelrienks`**
- `github-corp` -> GitHub user **`marcel-rienks`**

Validation commands:

```bash
ssh -T github-personal
ssh -T github-corp
```

Expected style of output:

```text
Hi marcelrienks! You've successfully authenticated, but GitHub does not provide shell access.
Hi marcel-rienks! You've successfully authenticated, but GitHub does not provide shell access.
```

## Why standard GitHub SSH URLs originally failed

A URL like:

```text
git@github.com:marcelrienks/spekificity.git
```

matches only the SSH host **`github.com`**.

SSH does **not** try unrelated host aliases like `github-personal` and `github-corp` one after another. It only uses config entries that match the host being connected to.

That means:

- SSH **can** try multiple keys from the **same agent** for one host
- SSH **cannot** automatically switch between the **Bitwarden agent** and the **1Password agent** for the same `github.com` connection

## Git URL rewrite solution

Global Git config now rewrites standard GitHub SSH URLs to the correct SSH alias based on the owner prefix.

Current rewrite rules:

```bash
git config --global url."git@github-personal:marcelrienks/".insteadOf "git@github.com:marcelrienks/"
git config --global url."git@github-corp:marcel.rienks/".insteadOf "git@github.com:marcel.rienks/"
```

You can view them with:

```bash
git config --global --get-regexp '^url\..*\.insteadOf$'
```

## Practical effect

These standard URLs can be copied directly from GitHub:

```text
git@github.com:marcelrienks/spekificity.git
git@github.com:marcel.rienks/some-repo.git
```

Git transparently rewrites them to:

```text
git@github-personal:marcelrienks/spekificity.git
git@github-corp:marcel.rienks/some-repo.git
```

So cloning works without manually editing the URL.

## Recommended usage

Use the normal GitHub SSH URL format when cloning:

```bash
git clone git@github.com:OWNER/REPO.git
```

If the owner prefix matches one of the rewrite rules, Git will route the connection through the correct SSH alias and therefore the correct agent.

## Important limitation

This setup works by **owner-based URL rewriting**, not by SSH automatically trying both agents.

If you add another personal or corporate owner/org later, add another rewrite rule:

```bash
git config --global url."git@github-corp:YOUR_ORG/".insteadOf "git@github.com:YOUR_ORG/"
```

or

```bash
git config --global url."git@github-personal:YOUR_USER/".insteadOf "git@github.com:YOUR_USER/"
```

## Agent socket paths

- Bitwarden: `/Users/marcel.rienks/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock`
- 1Password: `/Users/marcel.rienks/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`

## Quick troubleshooting

### Check which alias works

```bash
ssh -T github-personal
ssh -T github-corp
```

### Check rewrite rules

```bash
git config --global --get-regexp '^url\..*\.insteadOf$'
```

### Check which SSH config is in effect for an alias

```bash
ssh -G github-personal | grep -E 'hostname|user|identityagent'
ssh -G github-corp | grep -E 'hostname|user|identityagent'
```

### Probe repo access without cloning

```bash
git ls-remote git@github.com:marcelrienks/spekificity.git
```

If the owner prefix is covered by a rewrite rule, Git should route it automatically.
