# fzf options
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER=','
export FZF_PREVIEW_OPTS="
--bind='alt-k:preview-up'
--bind='alt-j:preview-down'
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
  fd --hidden --no-ignore --follow --exclude ".git" --exclude "node_modules" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --no-ignore --follow --exclude ".git" --exclude "node_modules" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd|ls)        fzf "$@" --height 100% --preview-window right --preview 'tree --dirsfirst -C {} -I node_modules | head -200' ;;
    cp|mv|rm|vim|nvim)     fzf "$@" --height 100% --preview-window right --preview '[ -d {} ] && tree --dirsfirst -C {} -I node_modules || bat --color=always {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --height 100% --preview-window down --preview 'dig {}' ;;
    # aws)          fzf "$@" ;;
    *)            fzf "$@" ;;
  esac
}

####################################################################################
#                                       GIT                                        #
####################################################################################

# Will return non-zero status if the current directory is not managed by git
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gt() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  # Pass the list of the tags to fzf-tmux
  # - "{}" in preview option is the placeholder for the highlighted entry
  # - Preview window can display ANSI colors, so we enable --color=always
  # - We can terminate `git show` once we have $LINES lines
  git tag --sort -version:refname |
    fzf-tmux --multi --preview-window right:70% \
             --preview 'git show --color=always {} | head -'$LINES
}

# A helper function to join multi-line output from fzf
join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

fzf-gt-widget() LBUFFER+=$(gt | join-lines)
zle -N fzf-gt-widget
bindkey '^g^t' fzf-gt-widget
