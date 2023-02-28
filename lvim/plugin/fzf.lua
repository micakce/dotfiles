vim.cmd("command! LS call fzf#run(fzf#wrap({'source': 'ls'}))")
vim.cmd([=[
command! Files call fzf#run(
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

command! FilesRG call fzf#run(
                         \  fzf#wrap(
                         \      {
                         \          'source': 'rg --column --line-number --no-heading --color=always --smart-case . ',
                         \          'sink': function("SplitColon"),
                         \          'options':[
                         \             '--info=inline', '--multi', '--ansi',
                         \              '--preview=[ -d $(echo {} | cut -f1 -d":") ] && tree --dirsfirst -C $(echo {} | cut -f1 -d":") -I node_modules ||  bat --color=always $(echo {} | cut -f1 -d":") --line-range $(N=`echo {} | cut -d : -f 2`; let "M=$N+100"; echo $N:$M) | head -200;',
                         \              '--prompt=FilesGrep> ',
                         \              GetFzfPreviewWindow()
                         \          ]
                         \      }
                         \   )
                         \ )

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

command! -nargs=* -bang FindRgFzf call RgFzf(<q-args>, <bang>0)
noremap <M-v> :FindRgFzf<CR>

command! -bang -nargs=* FindFzfMatchFileName
      \ call fzf#run(
              \ {
                \ fzf#wrap(
                \   'source': 'rg --hidden --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
             \          'options':[
             \             '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--ansi',
             \             '--preview=[ -d $(echo {} | cut -f1 -d":") ] && tree --dirsfirst -C $(echo {} | cut -f1 -d":") -I node_modules ||  bat --color=always $(echo {} | cut -f1 -d":") --line-range $(N=`echo {} | cut -d : -f 2`; let "M=$N+100"; echo $N:$M) | head -200;',
             \             '--info=inline', '--multi',
             \             '--prompt=FzfNameAndContent> ',
             \             GetFzfPreviewWindow()
             \          ]
                \         )
              \ }
)
nnoremap <M-f> :FindFzfMatchFileName<CR>

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

" noremap <M-f> :Files<CR>
noremap <M-g> :FilesRG<CR>

]=])
