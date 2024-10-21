# tmux-uni-ssh-agent

TMUX plugin to make sure a single agent is associated with a tmux server
It utilizes `ssh-find-agent` to find or create a ssh-agent to work with tmux server

# TMUX Options

|Option | Use|
|---|---|
| `@ssh-keys` | Path to ssh-key(s) space separated |
| `@do-not-export-ssh-auth-sock-i-already-have` | By default plugin exports variable on each new window or split, setting option disables this behaviour |

