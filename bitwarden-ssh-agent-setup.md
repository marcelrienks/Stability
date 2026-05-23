# Persistent setup: Use system ssh-agent by default, Bitwarden SSH agent for specific hosts (GitHub)

This document explains how to keep your machine's stock SSH agent as the default while using Bitwarden's SSH agent for specific targets (example: `github.com`). The goal: configure this once so it persists across restarts — no per-reboot scripts. macOS is covered first (primary), then Windows and WSL.

TL;DR
- Keep system ssh-agent as default and store your private keys there for general use.
- Install and enable Bitwarden Desktop SSH Agent and auto-start it at login.
- In `~/.ssh/config` use the `IdentityAgent` directive for specific hosts (e.g., `github.com`) and point it to Bitwarden's socket/pipe.
- Result: default operations use the system agent; connections to the specified host use Bitwarden and will prompt Bitwarden for authorization if configured.

---

Requirements
- macOS: Bitwarden Desktop (use the .dmg build for SSH Agent support on macOS), OpenSSH (system-provided), Git (if used for signing/push).  
- Windows: Bitwarden Desktop, PowerShell (admin for service changes). Note: Windows has a named-pipe limitation (see the Windows section).  
- WSL: `socat`, optionally `npiperelay.exe` (to bridge Windows named pipes into WSL).  
- Bitwarden Desktop: version with SSH Agent support (2025.1.2+ per Bitwarden release notes) — confirm in Bitwarden help/settings.

Concept (how this works)
- OpenSSH clients locate an agent through `SSH_AUTH_SOCK` (Unix socket) or, on Windows, a named pipe.  
- `IdentityAgent` in `~/.ssh/config` selects a per-host agent socket/pipe; if absent, the global `SSH_AUTH_SOCK` / default agent is used.  
- Keep the system agent as the default (no global change), and set `IdentityAgent` for the host(s) that should use Bitwarden's agent socket — persistent and requires no per-restart scripting.

---

macOS (recommended primary workflow)

Summary: keep macOS' ssh-agent + Keychain as default; install Bitwarden (DMG), enable its SSH agent, then set `IdentityAgent` for `github.com` to Bitwarden's socket path.

1) Ensure system (stock) ssh-agent is usable in shells
- macOS `launchd` normally starts an ssh-agent and GUI-launched shells inherit `SSH_AUTH_SOCK`. For safety add this to your shell RC so interactive shells see the same agent:

```sh
# ~/.zshrc or ~/.bash_profile
if [ -z "$SSH_AUTH_SOCK" ]; then
  export SSH_AUTH_SOCK=$(launchctl getenv SSH_AUTH_SOCK)
fi
```

2) Persist keys to Keychain so system agent is default across reboots
- Add your key to the macOS keychain (so it survives restarts and unlocks automatically):

```sh
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
# (replace with your key path)
```

- Recommended `~/.ssh/config` defaults for macOS:

```sshconfig
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

3) Install Bitwarden Desktop (DMG) and enable SSH Agent
- Download the Bitwarden Desktop `.dmg` from https://bitwarden.com/download/ (Mac App Store builds historically lacked SSH Agent support).  
- Open Bitwarden Desktop → Settings → Enable SSH agent. Note the SSH Agent socket path shown in the UI (copy it). Typical socket locations you might see:
  - `~/Library/Application Support/Bitwarden/ssh/agent.sock`  
  - or `~/Library/Application Support/Bitwarden/ssh/bitwarden-ssh-agent.sock`

- Enable “Start on login” (or add Bitwarden to Login Items) so the Bitwarden agent socket exists after every login.
- Check “Ask for authorization when using SSH agent” and choose the prompting behavior you prefer (Always / Never / Remember until vault is locked). The default is 'Always' (prompts when a key is used).

4) Configure `~/.ssh/config` to use Bitwarden for GitHub only
- Add a `Host` entry for github.com and point `IdentityAgent` to Bitwarden's socket (use the exact path from the Bitwarden Desktop settings). Quote paths containing spaces.

Example `~/.ssh/config` (macOS):

```sshconfig
# Use Bitwarden SSH agent for github.com only
Host github.com
  HostName github.com
  User git
  IdentityAgent "~/Library/Application Support/Bitwarden/ssh/agent.sock"
  IdentitiesOnly yes

# Default: use macOS keychain/system agent
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

Notes:
- Do NOT set `IdentitiesOnly yes` for the host if you want SSH to use the Bitwarden agent. `IdentitiesOnly yes` tells ssh to only use identity files configured in ssh_config and can prevent agent-offered keys from being used. Either remove that directive (recommended) or set `IdentitiesOnly no` to allow Bitwarden's agent keys to be offered.

- If Bitwarden's socket path differs on your machine, paste the path from Bitwarden's settings (the app displays it).

5) Test (macOS)
- Confirm system default keys are available:

```sh
ssh-add -l   # lists keys in the currently referenced agent (system agent if default)
```

- Test GitHub using the per-host Bitwarden agent:

```sh
ssh -T git@github.com -v
# Bitwarden should prompt for authorization on first use (if 'Ask for authorization' is enabled)
```

If authentication succeeds, the handshake shows "Hi <USER>! You've successfully authenticated..."

6) Convenience flow: auto-start Bitwarden + "Remember until vault is locked" (recommended)

This documents the path where Bitwarden Desktop auto-starts at login, you unlock once, and Bitwarden remembers SSH key authorizations until the vault locks. The result: a single interruption per login session (unlock + first SSH authorization), then seamless Git/SSH access while the vault remains unlocked.

Steps

- Enable auto-start: In Bitwarden Desktop Settings, enable "Start on login" (or add Bitwarden to macOS Login Items via System Settings → General → Login Items). This ensures Bitwarden (and its SSH agent socket) exist after each login.

- SSH Agent settings: In Bitwarden Desktop Settings → SSH Agent:
  - Enable SSH Agent.
  - Set "Ask for authorization when using SSH agent" to "Remember until vault is locked".
  - Optionally enable "Start agent on app start" if present.

- Unlocking at login:
  - After you log in, unlock Bitwarden Desktop once using your master password (or biometrics if configured). Note: on most platforms the first unlock after application start requires the master password; biometrics can be used for subsequent unlocks.

- First SSH use (authorization):
  - The first SSH operation that uses a Bitwarden-managed key (e.g., `ssh -T git@github.com -v` or `git push`) will trigger a Bitwarden authorization prompt. Authorize the operation and choose to remember the authorization until vault lock.
  - After authorization, subsequent SSH operations for that key will not prompt again until the vault locks.

When authorizations are cleared

- Bitwarden clears remembered SSH authorizations when the vault locks (manual lock, auto-lock idle, system lock/sleep if configured, app restart, or explicit log out).
- After a lock, you must unlock the vault and re-authorize the SSH key on first use.

Testing the flow

1. Ensure Bitwarden Desktop is running and you have enabled start-on-login and SSH agent options above.
2. Unlock Bitwarden Desktop (enter master password or use biometrics).
3. Run `ssh -T git@github.com -v`; accept the authorization prompt in Bitwarden.
4. Run `ssh -T git@github.com` again — it should not prompt.
5. Lock the vault (Bitwarden "Lock Vault" button or let auto-lock occur) or lock the macOS session. Run `ssh -T git@github.com` — Bitwarden should now prompt to unlock and authorize again.

Recommendations & trade-offs

- Convenience: "Remember until vault is locked" reduces prompts to the first SSH operation per session.
- Security: shorter auto-lock idle times and enabling "Lock on system lock" reduce the window where keys remain usable.
- Biometrics: enable biometric unlock (Touch ID) for faster re-unlock while keeping the initial master-password requirement on app start.
- If you require zero prompts ever, consider adding the key to the system Keychain instead. That loses vault-centric management and auditability.

Notes

- App restarts and system reboots will require you to unlock Bitwarden at least once after login before Bitwarden can serve SSH requests.
- If you want fully headless/scriptable behavior on servers, prefer the `bw` CLI approach (see earlier section), but note the CLI requires unlocking or storing a BW_SESSION which carries security tradeoffs.
---

Windows (notes & options)

Important limitation: on Windows the OpenSSH Authentication Agent (the `ssh-agent` service) and Bitwarden's SSH Agent can conflict because they expect exclusive access to the same named pipe. Bitwarden's docs note that to *enable* the Bitwarden SSH Agent on Windows you may need to disable the OpenSSH agent service (only one agent can own the pipe). This affects the "keep system agent as default and use Bitwarden only for a host" goal on Windows.

Two practical options:

Option A — Use system ssh-agent as default (no Bitwarden per-host on native Windows OpenSSH)
- If keeping OpenSSH agent service running is mandatory, Bitwarden cannot be the per-host agent on native Windows OpenSSH in many installations, because of the named-pipe conflict. In that case:
  - Keep the Windows OpenSSH agent running as the default agent.  
  - Use Bitwarden only in WSL (see WSL section) or in a Linux/macOS machine.

Option B — Make Bitwarden the Windows agent (Bitwarden as default)
- If acceptable to use Bitwarden as the Windows-wide agent (not per-host), disable the Windows ssh-agent and allow Bitwarden to own the pipe:

```powershell
# Run as Administrator
Get-Service ssh-agent | Set-Service -StartupType Disabled
Stop-Service ssh-agent
```

- Enable Bitwarden Desktop SSH Agent (Settings → Enable SSH Agent) and set Bitwarden to start on login.  
- Use a Windows ssh config entry to point to the Bitwarden named pipe (example):

```
# %USERPROFILE%\.ssh\config
Host github.com
  IdentityAgent //./pipe/bitwarden-ssh-agent
  IdentitiesOnly yes
```

Notes for Windows:
- Path format: `//./pipe/<pipe-name>` is accepted by OpenSSH on Windows. Some installs may use `\\.\pipe\<name>` — prefer the `//./pipe/` form in `ssh_config`.  
- If Bitwarden cannot run at the same time as the Windows `ssh-agent`, per-host behavior (stock agent default + Bitwarden for github only) is not available on native Windows OpenSSH. Use WSL workaround below if per-host is required while keeping Windows system agent.

---

WSL (Windows Subsystem for Linux) — bridge the Bitwarden Windows agent into WSL

Goal: access Bitwarden's Windows agent from inside WSL by bridging its named pipe to a Unix socket. This is the recommended workaround on Windows when needing both a Windows default agent and Bitwarden for selected targets in WSL.

Requirements: `npiperelay.exe`, `socat` (in WSL). `npiperelay` bridges Windows named pipes into WSL.

Example script (WSL) — create `~/bitwarden-ssh-relay.sh`:

```bash
#!/bin/bash
# Update the path to npiperelay if required (Windows side binary accessible from WSL)
NPIPERelay="/mnt/c/tools/npiperelay.exe"   # adjust
PIPE="//./pipe/bitwarden-ssh-agent"        # or //./pipe/openssh-ssh-agent if Bitwarden uses that
SOCK=/tmp/bitwarden-ssh-agent.sock

rm -f "$SOCK"
# Start socat relaying UN*IX socket to npiperelay (npiperelay bridges the Windows named pipe)

socat UNIX-LISTEN:"$SOCK",fork EXEC:"\"$NPIPERelay\" -ei -s $PIPE" &

# Export socket for the session
export SSH_AUTH_SOCK="$SOCK"
```

Make executable and run in WSL (or add to session startup):

```bash
chmod +x ~/bitwarden-ssh-relay.sh
~/bitwarden-ssh-relay.sh &
export SSH_AUTH_SOCK=/tmp/bitwarden-ssh-agent.sock
```

Add an ssh config entry inside WSL to use the local WSL socket for github.com:

```sshconfig
Host github.com
  IdentityAgent /tmp/bitwarden-ssh-agent.sock
  IdentitiesOnly yes
```

Test in WSL:

```bash
ssh-add -l    # lists Bitwarden-managed keys via the bridged socket
ssh -T git@github.com
```

Automation note: If WSL supports systemd, create a systemd service for the relay; otherwise add the relay to `~/.bashrc` with a check to avoid spawning duplicates.

---

Common `~/.ssh/config` examples (full sample)

```sshconfig
# Default behavior: system agent and macOS keychain
Host *
  AddKeysToAgent yes
  UseKeychain yes    # macOS only
  IdentityFile ~/.ssh/id_ed25519

# GitHub: use Bitwarden SSH Agent (macOS example)
Host github.com
  HostName github.com
  User git
  IdentityAgent "~/Library/Application Support/Bitwarden/ssh/agent.sock"
  IdentitiesOnly yes
```

Windows example (if Bitwarden owns the Windows pipe):

```sshconfig
Host github.com
  IdentityAgent //./pipe/bitwarden-ssh-agent
  IdentitiesOnly yes
```

WSL example (bridge socket):

```sshconfig
Host github.com
  IdentityAgent /tmp/bitwarden-ssh-agent.sock
  IdentitiesOnly yes
```

---

Testing & troubleshooting

1. Which agent is being used?
- macOS: `echo $SSH_AUTH_SOCK` and `launchctl getenv SSH_AUTH_SOCK`  
- WSL: `echo $SSH_AUTH_SOCK`  
- Windows: list named pipes or check your Bitwarden app settings for the pipe/socket path.

2. List keys available from the active agent (for the configured agent):

```sh
ssh-add -l
```

3. Verbose SSH debug (shows agent negotiation):

```sh
ssh -vvv git@github.com
```

- Look for lines showing which agent/socket/identities were offered and which key succeeded.

4. If Bitwarden doesn't prompt:
- Confirm Bitwarden Desktop is running and SSH Agent is enabled.  
- Confirm the socket path/pipe in Bitwarden settings matches what `IdentityAgent` points to.  
- Confirm Bitwarden setting "Ask for authorization when using SSH agent" is not set to "Never."  

5. macOS: If keys are not persistent after reboot:
- Make sure you used `ssh-add --apple-use-keychain ~/.ssh/id_ed25519` and `UseKeychain yes` in `~/.ssh/config`.

6. Windows: if you need Bitwarden per-host but also want the Windows service, prefer the WSL bridging approach. If you accept Bitwarden as the system agent, disable the Windows `ssh-agent` service (admin) and let Bitwarden own the pipe.

---

Notes & caveats
- On macOS prefer the system `ssh-agent`/Keychain for general interactive use; use Bitwarden for the hosts where you want the vault-backed prompts and centralized key management.  
- On Windows there is a named-pipe exclusivity constraint — Bitwarden may require disabling the Windows OpenSSH agent service to function as the active agent. That makes the "keep stock agent default and Bitwarden per-host" pattern hard to achieve on native Windows OpenSSH. Workarounds: use WSL bridging or make Bitwarden the system agent.  
- Always use the exact socket/pipe path shown in Bitwarden Desktop settings (paths can vary by install method).

References
- Bitwarden SSH Agent help: https://bitwarden.com/help/ssh-agent/  
- Bitwarden blog: https://bitwarden.com/blog/ssh-agent/  
- OpenSSH `ssh_config` manual (IdentityAgent): https://man.openbsd.org/ssh_config  
- Windows OpenSSH key management: https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement  
- npiperelay (WSL named pipe bridge): https://github.com/jstarks/npiperelay

---

If any of this should be adapted to a specific shell (fish), or if a ready-to-drop systemd unit / Windows service script is wanted for the WSL relay, say which environment and the doc can be extended with the exact service file and steps.