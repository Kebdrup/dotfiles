# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(/home/kristian/.local/bin/mise activate zsh)" # added by https://mise.run/zsh

alias vsp='tmux split-window -v'
alias sp='tmux split-window -h'
alias x='tmux resize-pane -x'
alias y='tmux resize-pane -y'
alias ll='ls -la'
alias vim='nvim'

# Automatically start tmux
if [[ -o interactive ]] && [[ -z "$TMUX" ]] && [[ -t 0 ]] && command -v tmux &>/dev/null; then
    exec tmux new-session
fi
