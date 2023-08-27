zstyle ':fzf-tab:*' popup-min-size 50 50
zstyle ':fzf-tab:completed:*' popup-pad 30 30
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-j:accept' 'ctrl-a:toggle-all' 'tab:toggle+down' 'shift-tab:toggle+up'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview '[ -f $realpath ] && head $realpath || exa -1 --color=always $realpath'
