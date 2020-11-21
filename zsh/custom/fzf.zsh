# fzf options
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER=','
export FZF_PREVIEW_OPTS="
--bind='alt-k:preview-up,alt-p:preview-up'
--bind='alt-j:preview-down,alt-n:preview-down'
--bind='ctrl-r:toggle-all'
--bind='ctrl-s:toggle-sort'
--bind='alt-p:toggle-preview'
--bind='alt-w:toggle-preview-wrap'"

export FZF_DEFAULT_OPTS="
$FZF_PREVIEW_OPTS
--height 100%
--cycle
--reverse
--border"

export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore --follow --glob "!{.git,node_modules}"'
export FZF_CTRL_T_COMMAND='rg --files --hidden --glob "!{node_modules}"'
# export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"'
export FZF_ALT_C_OPTS="--height 100% --preview-window down:50% --preview '[ -d {} ] && tree --dirsfirst -C {} -I node_modules || bat --color=always {} | head -200'"

function RG() { # fzf as filter and not fuzzy finder
RG_PREFIX='rg --column --line-number --no-heading --color=always --glob "!{node_modules}" --smart-case '
INITIAL_QUERY=""
FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" fzf \
    --bind "change:reload:$RG_PREFIX {q} || true" \
    --ansi --phony --query "$INITIAL_QUERY" \
    --preview 'bat --color=always $(echo {} | cut -d : -f 1 ) | head -200' \
    --preview-window="down:60%"
}
bindkey -s '\C-f' 'RG\n'

# # command to generate dir list
# _fzf_compgen_dir() {
#     rg --hidden --sort-files --files --glob "!{.git,node_modules}" --null 2> /dev/null  | xargs -0 dirname | uniq
# }

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd|ls)        fzf "$@" --height 100% --preview-window down --preview 'tree --dirsfirst -C {} -I node_modules | head -200' ;;
    cp|mv|rm|vim|nvim)     fzf "$@" --height 100% --preview-window down:50% --preview '[ -d {} ] && tree --dirsfirst -C {} -I node_modules || bat --color=always {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --height 100% --preview-window down --preview 'dig {}' ;;
    aws)          fzf "$@" ;;
    *)            fzf "$@" ;;
  esac
}
