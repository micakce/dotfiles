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

# bindkey -s ^a "nvims\n"
