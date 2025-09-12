alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-astro="NVIM_APPNAME=LunarVim nvim"

local DefaultEditor="LazyVim"

export NVIM_APPNAME=$DefaultEditor

function nvims() {
  items=("default" "LazyVim" "LunarVim" "LuaVim" "Lexical")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height='50%' --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    nvim $@
    return 0
  fi
  NVIM_APPNAME=$config nvim $@
}

# Clipboard aliases for both Wayland and X11
if [[ -n "$WAYLAND_DISPLAY" ]]; then
  # Wayland aliases
  alias cbread='wl-copy'
  alias cbprint='wl-paste'
else
  # X11 aliases
  alias cbread='xclip -selection clipboard'
  alias cbprint='xclip -o -selection clipboard'
fi

for f in zvm_backward_kill_region zvm_yank zvm_replace_selection zvm_change_surround_text_object zvm_vi_delete zvm_vi_change zvm_vi_change_eol; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { _$f \"\$@\"; echo -en \$CUTBUFFER | cbread }"
done

for f in zvm_vi_put_after zvm_vi_put_before zvm_vi_replace_selection; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { CUTBUFFER=\$(cbprint); _$f \"\$@\"; zvm_highlight clear }"
done


