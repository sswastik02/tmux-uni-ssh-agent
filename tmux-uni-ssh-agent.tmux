#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEFAULT_SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
get-tmux-option() {
  local option value default
  option="$1"
  default="$2"
  value="$(tmux show-option -gqv "$option")"

  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$default"
  fi
}

SSH_AUTH_SOCK="$(get-tmux-option "@ssh-auth-sock-path" "$DEFAULT_SSH_AUTH_SOCK")"
KEYS_LIST="$(get-tmux-option "@ssh-keys" "")"
NO_HOOKS="$(get-tmux-option "@do-not-export-ssh-auth-sock-i-already-have" "")"
EXPORT_SSH_AUTH_SOCK_COMMAND="send-keys 'export SSH_AUTH_SOCK=$SSH_AUTH_SOCK && clear' C-m"

if [ -z "$NO_HOOKS" ]
then
  tmux set-hook -g 'after-new-window' "$EXPORT_SSH_AUTH_SOCK_COMMAND"
  tmux set-hook -g 'after-split-window' "$EXPORT_SSH_AUTH_SOCK_COMMAND"
fi

# start ssh-agent with given SSH_AUTH_SOCK when tmux starts, if fails it is already running on socket
ssh-agent -a $DEFAULT_SSH_AUTH_SOCK || true 
SSH_AUTH_SOCK=$SSH_AUTH_SOCK ssh-add $KEYS_LIST

