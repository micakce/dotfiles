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


local function fzf_files()
  require('fzf-lua').files({ fzf_opts = {
    ['--layout'] = 'reverse-list',
  } })
end

vim.api.nvim_set_keymap('n', '<M-l>', '<cmd>lua fzf_files()<CR>', { noremap = true, silent = true })
-- local command = ":lua require('fzf-lua').files({ fzf_opts = { ['--layout'] = 'reverse-list' } })<CR>"
-- vim.api.nvim_set_keymap('n', '<M-l>', command, { noremap = true, silent = true })
