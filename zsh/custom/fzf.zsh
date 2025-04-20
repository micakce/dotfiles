# fzf options
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source <(fzf --zsh)

export FZF_COMPLETION_TRIGGER=','
export FZF_PREVIEW_OPTS="--bind='alt-k:preview-up' --bind='alt-j:preview-down' --bind='ctrl-r:toggle-all' --bind='ctrl-s:toggle-sort' --bind='alt-p:toggle-preview' --bind='alt-w:toggle-preview-wrap'"

export FZF_DEFAULT_OPTS="$FZF_PREVIEW_OPTS --height 100% --cycle --reverse --border"

export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore --follow --glob "!{.git,node_modules}"'
export FZF_CTRL_T_COMMAND='rg --files --hidden --glob "!{node_modules}"'
# export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"'
# export FZF_ALT_C_OPTS="--height 100% --preview-window down:50% --preview '[ -d {} ] && tree --dirsfirst -C {} -I node_modules || bat --color=always {} | head -200'"

function FzfFileNameAndContent() { # fzf as filter and not fuzzy finder
  local RG_PREFIX='rg --column --line-number --no-heading --color=always --glob "!{node_modules}" --smart-case '
  INITIAL_QUERY=""
  local selected=$(FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" fzf \
    --delimiter : \
    --ansi --query "$INITIAL_QUERY" \
    --preview 'bat --color=always {1} --line-range $(N={2}; let "M=$N+100"; echo $N:$M)' \
    -m \
    --preview-window="down:60%")

  # filename="${selected%%:*}"
  # echo "Filename $filename"
  # rest_of_line="${selected#*:}"
  # echo "rest_of_line $rest_of_line"
  # line_number="${rest_of_line%%:*}"
  if [ "$(echo $selected | wc -l )" = "1" ]; then 
    # Extract filename and line number using pattern matching
    if [[ $selected =~ ^([^:]+):([0-9]+): ]]; then
      filename="${match[1]}"
      line_number="${match[2]}"
      # Construct the desired command
      local cmd="nvim '$filename' +$line_number"
      print -z $cmd
    fi
  else
    local cmd="nvim"
    for line ($=selected); do
      if [[ $line =~ ^([^:]+):([0-9]+): ]]; then
        cmd+=" ${match[1]}"
      fi
    done
    print -z $cmd
  fi
}
bindkey -s '\C-f' 'FzfFileNameAndContent\n'

function RGwithFzf() { # fzf as filter and not fuzzy finder
local RG_PREFIX='rg --column --line-number --no-heading --color=always --glob "!{node_modules}" --smart-case '
INITIAL_QUERY=""
local selected=$(FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" fzf \
    --delimiter : \
    -m \
    --bind "change:reload:$RG_PREFIX {q} || true" \
    --ansi --disabled --query "$INITIAL_QUERY" \
    --preview 'bat --color=always {1} --line-range $(N={2}; let "M=$N+100"; echo $N:$M)' \
    --preview-window="down:60%")

  if [ "$(echo $selected | wc -l )" = "1" ]; then 
    # Extract filename and line number using pattern matching
    if [[ $selected =~ ^([^:]+):([0-9]+): ]]; then
      filename="${match[1]}"
      line_number="${match[2]}"
      # Construct the desired command
      local cmd="nvim '$filename' +$line_number"
      print -z $cmd
    fi
  else
    local cmd="nvim"
    for line ($=selected); do
      if [[ $line =~ ^([^:]+):([0-9]+): ]]; then
        cmd+=" ${match[1]}"
      fi
    done
    print -z $cmd
  fi
}
bindkey -s '\C-g' 'RGwithFzf\n'


# # command to generate dir list
# _fzf_compgen_dir() {
#     rg --hidden --sort-files --files --glob "!{.git,node_modules}" --null 2> /dev/null  | xargs -0 dirname | uniq
# }

_fzf_compgen_path() {
  fd --hidden --no-ignore --follow --exclude ".git" --exclude "node_modules" --exclude "dist" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --no-ignore --follow --exclude ".git" --exclude "node_modules" --exclude "dist" . "$1"
}


get_preview_window() {
  if [[ $FZF_PREVIEW_COLUMNS -le 5 ]]; then
    echo "down:80%"
  else
    echo "right"
  fi
}

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd|ls)              fzf "$@" --height 100% --preview-window down:60% --preview 'tree --dirsfirst -C {} -I node_modules | head -200' ;;
    cp|mv|rm|vim|nvim|lvim|docker)  fzf "$@" --height 100% --preview-window $(get_preview_window) --preview '[ -d {} ] && tree --dirsfirst -C {} -I node_modules || if [[ $(file -b {}) =~ ^"JPEG " ]]; then viu {}; else bat --color=always {} | head -200; fi;' ;;
    export|unset)       fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)                fzf "$@" --height 100% --preview-window down --preview 'dig {}' ;;
    *)                  fzf "$@" ;;
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


fzf_gdiff() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

# Open all files modified in commit 
fcommit(){
    vim $(git diff-tree --no-commit-id --name-only -r $1)
}

####################################################################################
#                                  MISCELLANEOUS                                   #
####################################################################################


runhis() {
    history | fzf -m -q "$1" | awk '{ print substr($0, index($0,$4))  }' | bash
}

c() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}
