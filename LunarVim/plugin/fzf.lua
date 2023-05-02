local fzf_defaults = require 'fzf-lua'.defaults

fzf_defaults.git.bcommits.actions = {
  ["default"] = require 'fzf-lua'.actions.git_buf_edit,
  ["ctrl-s"]  = require 'fzf-lua'.actions.git_buf_split,
  ["ctrl-v"]  = function(selected, _)
    local commit_hash = selected[1]:match("[^ ]+")
    local cmd = string.format("Gvdiffsplit %s", commit_hash)
    vim.cmd(cmd)
  end,
  ["ctrl-t"]  = require 'fzf-lua'.actions.git_buf_tabedit,
}

vim.api.nvim_create_user_command(
  'Lcommits',
  function(opts)
    vim.cmd("messages clear")
    for key, value in pairs(opts) do
      print('\t', key, value)
    end
    local start_line = opts.line1
    local end_line = opts.line2
    require 'fzf-lua'.git_bcommits({
      prompt = "LCommits> ",
      cmd    = "git log " ..
          opts.args .. " --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))" ..
          "%Creset %s %C(blue)<%an>%Creset' -L " .. start_line .. "," .. end_line .. ":<file> --no-patch",
    })
  end,
  {
    nargs = '*',
    range = true,
    force = true,
  })

require 'fzf-lua'.setup(fzf_defaults)

vim.cmd("command! LS call fzf#run(fzf#wrap({'source': 'ls'}))")
vim.cmd([=[
command! FilesByName call fzf#run(
\  fzf#wrap(
\      {
\          'source': 'fd -t f', 
\          'options':[
\             '--info=inline', '--multi',
\              '--preview=[ -d {} ] && tree --dirsfirst -C {} -I node_modules ||  bat --color=always {} | head -200;',
\              '--prompt=Files> ',
\              GetFzfPreviewWindow()
\          ]
\      }
\   )
\ )

command! -bang -nargs=* FilesByNameAndContent call fzf#run(
\ fzf#wrap(
\ {
\ 'source': 'rg --hidden --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
\ 'sink': function("SplitColon"),
\ 'options':[
\ '--ansi',
\ '--preview=[ -d $(echo {} | cut -f1 -d":") ] && tree --dirsfirst -C $(echo {} | cut -f1 -d":") -I node_modules ||  bat --color=always $(echo {} | cut -f1 -d":") --line-range $(N=`echo {} | cut -d : -f 2`; let "M=$N+100"; echo $N:$M) | head -200;',
\ '--info=inline', '--multi',
\ '--prompt=FzfNameAndContent> ',
\ GetFzfPreviewWindow()
\ ]
\ }
\ )
\ )


function! RgFzf(query, fullscreen)
  let command_fmt = 'rg --smart-case --column --hidden --line-number --no-heading --color=always %s --glob "!{node_modules}" || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': []}
  call fzf#run(
             \  fzf#wrap(
             \      {
             \          'source': initial_command,
             \          'sink': function("SplitColon"),
             \          'options':[
             \             '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--ansi',
             \             '--preview=[ -d $(echo {} | cut -f1 -d":") ] && tree --dirsfirst -C $(echo {} | cut -f1 -d":") -I node_modules ||  bat --color=always $(echo {} | cut -f1 -d":") --line-range $(N=`echo {} | cut -d : -f 2`; let "M=$N+100"; echo $N:$M) | head -200;',
             \             '--info=inline', '--multi',
             \             '--prompt=FZFRegEx> ',
             \             GetFzfPreviewWindow()
             \          ]
             \      }
             \   )
             \ )
endfunction
command! -nargs=* -bang FilesByContentWithRegEx call RgFzf(<q-args>, <bang>0)

command! Buff call fzf#run(
\  fzf#wrap(
\      {
\          'source': map(copy(getbufinfo()), 'v:val.bufnr'),
\          'options':[
\             '--info=inline', '--multi',
"\              '--preview=[ -d $(echo {} | cut -f1 -d":") ] && tree --dirsfirst -C $(echo {} | cut -f1 -d":") -I node_modules ||  bat --color=always $(echo {} | cut -f1 -d":") | head -200;',
\              '--prompt=Buffers> ',
"\              GetFzfPreviewWindow()
\          ]
\      }
\   )
\ )


function! SplitColon(file)
  let filename = split(a:file, ':')[0]
  execute 'edit' l:filename
endfunction

function! GetFzfPreviewWindow()
  if &columns < 160
    return '--preview-window=down:80%'
  else
    return '--preview-window=right:70%'
  endif
endfunction

noremap <M-f> :FilesByName<CR>
nnoremap <M-S-f> :FilesByNameAndContent<CR>
noremap <M-g> :FilesByContentWithRegEx<CR>
]=])
